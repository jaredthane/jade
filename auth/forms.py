from django import forms

class LoginForm(forms.Form):
	username = forms.CharField()
	password = forms.PasswordField()

