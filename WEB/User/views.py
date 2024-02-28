from django.shortcuts import render,redirect
import firebase_admin 
from firebase_admin import firestore,credentials,storage,auth
import pyrebase
from django.core.mail import send_mail
from django.conf import settings
from django.contrib import messages

db=firestore.client()

config = {
  "apiKey": "AIzaSyC-B9e73ulMpTAHH4DXU0iY31N5UfaZ-SY",
  "authDomain": "stellar-powers.firebaseapp.com",
  "projectId": "stellar-powers",
  "storageBucket": "stellar-powers.appspot.com",
  "messagingSenderId": "584258827192",
  "appId": "1:584258827192:web:0732d9ba85c02c7f93d54d",
  "measurementId": "G-LD235E67QN",
  "databaseURL":""
}

firebase = pyrebase.initialize_app(config)
authe = firebase.auth()
st = firebase.storage()

# Create your views here.

def homepage(request):
    return render(request,"user/Homepage.html")


def Myprofile (request):
    user = db.collection("tbl_userreg").document(request.session["uid"]).get().to_dict()
    return render(request,"User/Myprofile.html",{"user":user})

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

def products(request):
    return render(request,"User/Products.html")
    
def review(request):
    return render(request,"User/Review.html")

