from flask import Flask, redirect, request, jsonify
from flask_awscognito import AWSCognitoAuthentication
app = Flask(__name__)

app.config['AWS_DEFAULT_REGION'] = 'us-east-1'
app.config['AWS_COGNITO_DOMAIN'] = 'domain.com'
app.config['AWS_COGNITO_USER_POOL_ID'] = 'INSERT_AWS_COGNITO_USER_POOL_ID'
app.config['AWS_COGNITO_USER_POOL_CLIENT_ID'] = 'INSERT_AWS_COGNITO_USER_POOL_CLIENT_ID'
app.config['AWS_COGNITO_USER_POOL_CLIENT_SECRET'] = ''
app.config['AWS_COGNITO_REDIRECT_URL'] = 'https://localhost:5000/aws_cognito_redirect'


aws_auth = AWSCognitoAuthentication(app)


@app.route('/')
@aws_auth.authentication_required
def index():
    claims = aws_auth.claims # also available through g.cognito_claims
    return jsonify({'claims': claims})


@app.route('/aws_cognito_redirect')
def aws_cognito_redirect():
    access_token = aws_auth.get_access_token(request.args)
    return jsonify({'access_token': access_token})


@app.route('/sign_in')
def sign_in():
    return redirect(aws_auth.get_sign_in_url())


if __name__ == '__main__':
    app.run(host ='0.0.0.0', port = 5000, debug = True)
