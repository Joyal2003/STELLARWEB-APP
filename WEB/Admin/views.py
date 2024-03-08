from django.shortcuts import render,redirect
import firebase_admin 
from firebase_admin import firestore,credentials,storage,auth
import pyrebase
from django.core.mail import send_mail
from django.conf import settings
from django.contrib import messages

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

def district(request):
    dis=db.collection("tbl_district").stream()
    dis_data=[]
    for i in dis:
        data=i.to_dict()
        dis_data.append({"dis":data,"id":i.id})
    if request.method=="POST":
        data={"district_name":request.POST.get("district")}
        db.collection("tbl_district").add(data)
        return redirect("webadmin:district")
    else:
        return render(request,"Admin/District.html",{"district":dis_data})

def editdistrict(request,id):
    dis=db.collection("tbl_district").document(id).get().to_dict()
    if request.method=="POST":
       data={"district_name":request.POST.get("district")}
       db.collection("tbl_district").document(id).update(data)
       return redirect("webadmin:district")
    else:
        return render(request,"Admin/District.html",{"dis_data":dis})
        
def deldistrict(request,id):
    db.collection("tbl_district").document(id).delete()
    return redirect("webadmin:district")

def Place(request):
    dis=db.collection("tbl_district").stream()
    dis_data=[]
    for i in dis:
        data=i.to_dict()
        dis_data.append({"dis":data,"id":i.id})
    result=[]
    place_data=db.collection("tbl_place").stream()
    for place in place_data:
        place_dict=place.to_dict()
        district=db.collection("tbl_district").document(place_dict["district_id"]).get()
        district_dict=district.to_dict()
        result.append({'districtdata':district_dict,'place_data':place_dict,'placeid':place.id})
    if request.method=="POST":
        data={"place_name":request.POST.get("place"),"district_id":request.POST.get("district")}
        db.collection("tbl_place").add(data)
        return redirect("webadmin:Place")
    else:
        return render(request,"Admin/Place.html",{"district":dis_data,"place":result})


def delplace(request,id):
    db.collection("tbl_place").document(id).delete()
    return redirect("webadmin:Place")        

def editplace(request,id):
    dis = db.collection("tbl_district").stream()
    dis_data = []
    for d in dis:
        dis_data.append({"dis":d.to_dict(),"id":d.id})
    place_data=db.collection("tbl_place").document(id).get().to_dict()
    if request.method=="POST":
       place_data={"place_name":request.POST.get("place"),"district_id":request.POST.get("district")}
       db.collection("tbl_place").document(id).update(place_data)
       return redirect("webadmin:Place")
    else:
        return render(request,"Admin/Place.html",{"place_data":place_data,"district":dis_data})

def producttype(request):
    pty=db.collection("tbl_producttype").stream()
    pty_data=[]
    for i in pty:
        data=i.to_dict()
        pty_data.append({"pty":data,"id":i.id})
    if request.method=="POST":
        data={"producttype_name":request.POST.get("producttype_name")}
        db.collection("tbl_producttype").add(data)
        return redirect("webadmin:producttype")
    else:
        return render(request,"Admin/Producttype.html",{"producttype":pty_data})

def editproducttype(request,id):
    pty=db.collection("tbl_producttype").document(id).get().to_dict()
    if request.method=="POST":
       data={"producttype_name":request.POST.get("producttype")}
       db.collection("tbl_producttype").document(id).update(data)
       return redirect("webadmin:producttype")
    else:
       return render(request,"Admin/Producttype.html",{"pty_data":pty})
        
def delproducttype(request,id):
    db.collection("tbl_producttype").document(id).delete()
    return redirect("webadmin:producttype")



def types(request):
    pdt=db.collection("tbl_type").stream()
    pdt_data=[]
    for i in pdt:
        data=i.to_dict()
        pdt_data.append({"pdt":data,"id":i.id})
    if request.method=="POST":
        data={"type_name":request.POST.get("type_name")}
        db.collection("tbl_type").add(data)
        return redirect("webadmin:types")
    else:
        return render(request,"Admin/Type.html",{"type":pdt_data})



def admin(request):
    if request.method =="POST":
        email = request.POST.get("email")
        password = request.POST.get("password")
        try:
            admin = firebase_admin.auth.create_user(email=email,password=password)
        except (firebase_admin._auth_utils.EmailAlreadyExistsError,ValueError) as error:
            return render(request,"Admin/Adminregistration.html",{"msg":error})
        db.collection("tbl_admin").add({"admin_id":admin.uid,"admin_name":request.POST.get("name"),"admin_contact":request.POST.get("contact"),"admin_email":request.POST.get("email")})    
        return render(request,"Admin/Adminregistration.html")
    else:
        return render(request,"Admin/Adminregistration.html")


def servicebooking(request):
    ser=db.collection("tbl_servicerequest").stream()
    ser_data=[]
    for i in ser:
        data=i.to_dict()
        user = db.collection("tbl_userreg").document(data["user_id"]).get().to_dict()
        producttype = db.collection("tbl_producttype").document(data["producttype_id"]).get().to_dict()
        types = db.collection("tbl_type").document(data["type_id"]).get().to_dict()
        ser_data.append({"view":data,"id":i.id,"user":user,"producttype":producttype,"types":types})
        
    return render(request,"Admin/servicebooking.html",{"view":ser_data})

def accepted(request,id):
    req=db.collection("tbl_servicerequest").stream()
    if request.method=="POST":
        day = request.POST.get("date") 
        data={"date":request.POST.get("date"),"service_status":1}
        db.collection("tbl_servicerequest").document(id).update(data)
        user = db.collection("tbl_userreg").document(request.session["uid"]).get().to_dict()
        email = user["user_email"]
        send_mail(
        'Service Booking', 
        "\rHello \r\n Your service booking has accepted our technishian will  contact you in " + day,#body
        settings.EMAIL_HOST_USER,
        [email],
        )
        return render(request,"Admin/servicebooking.html",{"msg":email})
    else:
        return render(request,"Admin/Servicereplay.html")
    


def rejected(request,id):
    req=db.collection("tbl_servicerequest").document(id).update({"service_status":2})
    user = db.collection("tbl_userreg").document(request.session["uid"]).get().to_dict()
    email = user["user_email"]
    send_mail(
    'Service Booking', 
    "\rHello \r\n Your service booking has rejected our technishian ",#body
    settings.EMAIL_HOST_USER,
    [email],
    )
    return render(request,"Admin/servicebooking.html",{"msg":email}) 

def completed(request,id):
    req=db.collection("tbl_servicerequest").document(id).update({"service_status":3})
    user = db.collection("tbl_userreg").document(request.session["uid"]).get().to_dict()
    email = user["user_email"]
    send_mail(
    'Service Booking', 
    "\rHello \r\n Your service is completed ",#body
    settings.EMAIL_HOST_USER,
    [email],
    )
    return render(request,"Admin/servicebooking.html",{"msg":email}) 
 


def servicereplay(request):
    return render(request,"Admin/Servicereplay.html")

def complaintreplay(request):
    return render(request,"Admin/Complaintreplay.html")

def homepage(request):
    return render(request,"Admin/Homepage.html")






