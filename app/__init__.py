from flask import Flask, redirect, request, jsonify
from flask_awscognito import AWSCognitoAuthentication
app = Flask(__name__)

app.config['AWS_DEFAULT_REGION'] = 'us-east-1'
app.config['AWS_COGNITO_DOMAIN'] = 'bbb-random-example-domain.auth.us-east-1.amazoncognito.com'
app.config['AWS_COGNITO_USER_POOL_ID'] = 'INSERT_AWS_COGNITO_USER_POOL_ID'
app.config['AWS_COGNITO_USER_POOL_CLIENT_ID'] = 'INSERT_AWS_COGNITO_USER_POOL_CLIENT_ID'
app.config['AWS_COGNITO_USER_POOL_CLIENT_SECRET'] = ''
app.config['AWS_COGNITO_REDIRECT_URL'] = 'https://localhost:5000/aws_cognito_redirect'

aws_auth = AWSCognitoAuthentication(app)





from app import routes
