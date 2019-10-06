import flask
from werkzeug.utils import secure_filename
import os
from flask import request
import random
from flask import abort
from flask import request, jsonify, Flask
from itsdangerous import TimedJSONWebSignatureSerializer
from flask import send_file
from urllib.parse import urljoin, urlsplit
from flask_sslify import SSLify
from werkzeug.contrib.fixers import ProxyFix
TOKEN = "asdfadfadfas"

a = TimedJSONWebSignatureSerializer(TOKEN, 60)

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = "./videos"

# sslify = SSLify(app)
app.wsgi_app = ProxyFix(app.wsgi_app)

GLABAL_TOKEN = {}
GLABAL_FILE = {}
class APIException(Exception):
    errCode = 0
    errMsg = ""
    def __init__(self, errMsg=""):
        if errMsg:
            self.errMsg = errMsg

    def to_json(self):
        return {
            "errCode": self.errCode,
            "errMsg": self.errMsg
        }

def fake_login_required(func):
    def wrapper(*args, **kwargs):
        auth = request.headers.get("Authorization", "")
        if not auth:
            return func(*args, **kwargs)
        token = auth.rsplit(" ")[-1]
        try:
            a.loads(token)
        except:
            raise APIException("认证失败:{}".format(token))    
        else:
            return func(*args, **kwargs)
    return wrapper

def capture(func):
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except APIException as e:
            return jsonify(e.to_json())
    return wrapper

@capture
@fake_login_required
@app.route("/api/v1/video/upload", methods=['POST'])
def upload():
    file = request.files['file']
    device_width = (request.json or request.form).get('width')
    device_height = (request.json or request.form).get('height')
    filename = secure_filename(file.filename)
    print(f'设备的高度:{device_height},宽度:{device_width}，视频名称:{filename}')
    file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
    u = str(random.random() * 1000000000)
    GLABAL_FILE[u] = filename
    return jsonify({"errCode": 0,"errMsg": "", "data": u})

@app.route("/api/v1/verify_code", methods=["POST"])
def aa():
    phone = request.json.get("phone")
    print("获取手机号", phone)
    return jsonify({"errCode": 0, "errMsg":"", "data":"777777"})

@app.route("/api/v1/user/login", methods=["POST"])
def aab():
    phone = request.json.get("phone")
    verifyCode = request.json.get("verifyCode")
    print("获取手机号", phone)
    print("获取验证码", verifyCode)
    if phone == "11111111111":
        
        token = a.dumps({"uid": 1, "phone": phone}).decode()
        GLABAL_TOKEN[token] = phone
        return jsonify({"errCode": 0, "errMsg":"登录成功","token": token})
    return jsonify({"errCode": 123, "errMsg":"验证码错误"})


@capture
@fake_login_required
@app.route("/api/v1/user/info", methods=["GET"])
def info():
    auth = request.headers.get("Authorization", "")
    token = auth.rsplit(" ")[-1]
    return jsonify({"errCode": 0, "data":{"phone": GLABAL_TOKEN.get(token)}})

@capture
@fake_login_required
@app.route("/api/v1/user/logout", methods=["POST"])
def logout():
    auth = request.headers.get("Authorization", "")
    token = auth.rsplit(" ")[-1]
    try:
        GLABAL_TOKEN.pop(token)
    except KeyError:
        pass
    return jsonify({'errrCode': 0, 'errMsg': "success."})
@capture
@fake_login_required
@app.route("/api/v1/user/peoples", methods=["GET"])
def peoples():
    print(request.headers)
    return jsonify({
        "errCode": 0,
        "errMsg": "",
        "data": {
            "lineCount": 3,
            "choicePeoples": [
            {
                "icon": "assets/images/avatars/1.png",
                "name": "人物1",
                "lock": True
            },
            {
                "icon": "assets/images/avatars/2.png",
                "name": "人物2",
                "lock": False
            },
            {
                "icon": "assets/images/avatars/3.png",
                "name": "人物3",
                "lock": True
            },
            {
                "icon": "assets/images/avatars/4.png",
                "name": "人物4",
                "lock": True
            },
            {
                "icon": "assets/images/avatars/5.png",
                "name": "人物5",
                "lock": True
            },
            {
                "icon": "assets/images/avatars/6.png",
                "name": "人物1",
                "lock": False
            },
            {
                "icon": "assets/images/avatars/7.png",
                "name": "人物7",
                "lock": True
            },
        ]
        }
    })


@app.route('/api/v1/video/url', methods=['POST'])
def retrieve_video_url():
    # 不断轮训，知道处理完成，获取url
    mark = (request.form or request.json).get("mark")
   
    import time
    time.sleep(1)
    value = random.choice([1,2])
    print(f"{mark} 正在处理中。。。选择的值为:{value}")
    if value != 1:
        return jsonify({"errCode": 123, "errMsg": "未处理完成"})

    s = urlsplit(request.url)
    url = f"{s.scheme}://{s.netloc}/api/v1/video/{GLABAL_FILE[mark]}"
    # "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4"
    return jsonify({
        "errCode": 0,
         "errMsg": "处理完成", 
         "data": "https://netease.im/res/video/face/video03.mp4"
})
    


@app.route("/api/v1/video/<string:address>", methods=["GET"])
def retrieve_video(address):
    print(address)
    return send_file(f"./videos/{address}")


@app.route("/api/v1/video/text", methods=["POST"])
def post_text():
    text = (request.form or request.json).get("text")
    mark = (request.form or request.json).get("mark")
    print(f"文件{GLABAL_FILE.get(mark)}上传的对应文字为:{text}")
    return jsonify({"errCode": 0, "errMsg": ""})

if __name__ == "__main__":
    app.run(host="0.0.0.0")
