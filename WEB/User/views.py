from django.shortcuts import render,redirect
import firebase_admin 
from firebase_admin import firestore,credentials,storage,auth
import pyrebase
from django.core.mail import send_mail
from django.conf import settings
from django.contrib import messages
from datetime import date

db=firestore.client()

config = {
  "apiKey": "AIzaSyAIAg5LMCrWYb9Ytx73UNY8Rtq8E5ia3Uk",
  "authDomain": "stellarpower-e2086.firebaseapp.com",
  "projectId": "stellarpower-e2086",
  "storageBucket": "stellarpower-e2086.appspot.com",
  "messagingSenderId": "714960895991",
  "appId": "1:714960895991:web:989fefb9d9f1f3621df8f2",
  "measurementId": "G-3JZERD4240",
  "databaseURL":""
}

firebase = pyrebase.initialize_app(config)
authe = firebase.auth()
st = firebase.storage()

# Create your views here.

def homepage(request):
    return render(request,"user/Homepage.html")


def Myprofile (request):
  if "uid" in request.session:
    user = db.collection("tbl_userreg").document(request.session["uid"]).get().to_dict()
    return render(request,"User/Myprofile.html",{"user":user})
  else:
    return render(request,"Guest/Login.html")  

def Editprofile(request):
  user = db.collection("tbl_userreg").document(request.session["uid"]).get().to_dict()
  if request.method=="POST":
    data={"user_name":request.POST.get("name"),"user_contact":request.POST.get("contact"),"user_address":request.POST.get("address")}
    db.collection("tbl_userreg").document(request.session["uid"]).update(data)
    return redirect("webuser:Myprofile")
  else:
    return render(request,"User/EditProfile.html",{"user":user})  


def changepassword(request):
  user = db.collection("tbl_userreg").document(request.session["uid"]).get().to_dict()
  email = user["user_email"]
  password_link = firebase_admin.auth.generate_password_reset_link(email) 
  send_mail(
    'Reset your password ', 
    "\rHello \r\nFollow this link to reset your Project password for your " + email + "\n" + password_link +".\n If you didn't ask to reset your password, you can ignore this email. \r\n Thanks. \r\n Your D MARKET user.",#body
    settings.EMAIL_HOST_USER,
    [email],
  )
  return render(request,"User/Homepage.html",{"msg":email})


def complaint(request):
  com=db.collection("tbl_complaint").where("user_id","==",request.session["uid"]).stream()
  com_data=[]
  for i in com:
    data=i.to_dict()
    com_data.append({"com":data,"id":i.id})
  if request.method=="POST":
    datedata = date.today()
    data={"team_id":0,"complaint_content":request.POST.get("content"),"user_id":request.session["uid"],"complaint_status":0,"complaint_date":str(datedata)}
    db.collection("tbl_complaint").add(data)
    return redirect("webuser:complaint")
  else:
    return render(request,"User/Complaint.html",{"com":com_data})


def delcomplaint(request,id):
  db.collection("tbl_complaint").document(id).delete()     
  return redirect("webuser:complaint")  

def servicerequest(request):
  ser=db.collection("tbl_servicerequest").where("user_id","==",request.session["uid"]).stream()
  ser_data=[]
  for i in ser:
    data=i.to_dict()
    ser_data.append({"ser":data,"id":i.id})
  pty = db.collection("tbl_producttype").stream()
  pty_data = []
  for d in pty:
        pty_data.append({"pty":d.to_dict(),"id":d.id})
  pdt = db.collection("tbl_type").stream()
  pdt_data = []
  for d in pdt:
        pdt_data.append({"pdt":d.to_dict(),"id":d.id})
  if request.method=="POST":
    datedata = date.today()
    data={"service_content":request.POST.get("content"),"user_id":request.session["uid"],"producttype_id":request.POST.get("sel_producttype"),"type_id":request.POST.get("sel_type"),"service_status":0,"service_date":str(datedata),"feedback_content":""}
    db.collection("tbl_servicerequest").add(data)
    return redirect("webuser:servicerequest")
  else:
    return render(request,"User/Servicerequest.html",{"ser":ser_data,"producttype":pty_data,"type":pdt_data})

def products(request):
    return render(request,"User/Products.html")
    
def feedback(request,id):
  if request.method=="POST":
    db.collection("tbl_servicerequest").document(id).update({"feedback_content":request.POST.get("content")})
    return render(request,"User/Feedback.html")
  else:
    return render(request,"User/Feedback.html")

def myservice(request):
  ser=db.collection("tbl_servicerequest").stream()
  ser_data=[]
  for i in ser:
    data=i.to_dict()
    ser_data.append({"view":data,"id":i.id})
  return render(request,"User/MyService.html",{"view":ser_data})    

def logout(request):
    del request.session["uid"]
    return redirect("webguest:index")