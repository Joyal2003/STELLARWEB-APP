from django.shortcuts import render,redirect
import firebase_admin 
from firebase_admin import firestore,credentials,storage,auth
import pyrebase

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
def index(request):
    return render(request,"Guest/index.html")


def login(request):
    userid=""
    adminid=""
    if request.method == "POST":
        email = request.POST.get("email")
        password = request.POST.get("password")
        try:
            data = authe.sign_in_with_email_and_password(email,password)
        except:
            return render(request,"Guest/Login.html",{"msg":"Error in Email Or Password"})
        admin=db.collection("tbl_admin").where("admin_id","==",data["localId"]).stream() 
        for a in admin:
            adminid=a.id   
        user=db.collection("tbl_userreg").where("user_id","==",data["localId"]).stream()    
        for u in user:
            userid=u.id 
        if userid:
            request.session["uid"]=userid
            return redirect("webuser:homepage")   
        elif adminid:
            request.session["aid"]=adminid 
            return redirect("webadmin:homepage")  
        else:
            return render(request,"Guest/Login.html",{"msg":"error"})    
    else:
       return render(request,"Guest/Login.html")            

def userreg(request):
    dis = db.collection("tbl_district").stream()
    dis_data = []
    for d in dis:
        dis_data.append({"dis":d.to_dict(),"id":d.id})
    if request.method =="POST":
        email = request.POST.get("uemail")
        password = request.POST.get("password")
        try:
            user = firebase_admin.auth.create_user(email=email,password=password)
        except (firebase_admin._auth_utils.EmailAlreadyExistsError,ValueError) as error:
            return render(request,"Guest/User.html",{"msg":error})
        image = request.FILES.get("uphoto")
        if image:
            path = "UserPhoto/" + image.name
            st.child(path).put(image)
            u_url = st.child(path).get_url(None)
         
        db.collection("tbl_userreg").add({"user_id":user.uid,"user_name":request.POST.get("uname"),"user_contact":request.POST.get("ucontact"),"user_email":request.POST.get("uemail"),"user_address":request.POST.get("uaddress"),"place_id":request.POST.get("sel_place"),"user_photo":u_url})
        return render(request,"Guest/Userreg.html")
    else:
        return render(request,"Guest/Userreg.html",{"district":dis_data})

def ajaxplace(request):
    place = db.collection("tbl_place").where("district_id", "==", request.GET.get("did")).stream()
    place_data = []
    for p in place:
        place_data.append({"place":p.to_dict(),"id":p.id})
    return render(request,"Guest/AjaxPlace.html",{"place":place_data})

