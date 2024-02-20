from django.shortcuts import render,redirect
import firebase_admin 
from firebase_admin import firestore,credentials,storage,auth
import pyrebase

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

def product(request):
    pdt=db.collection("tbl_producttype").stream()
    pdt_data=[]
    for i in pdt:
        data=i.to_dict()
        pdt_data.append({"pdt":data,"id":i.id})
    result=[]
    product_data=db.collection("tbl_product").stream()
    for product in product_data:
        product_pdtd=product.to_dict()
        producttype=db.collection("tbl_producttype").document(product_pdtd["producttype_id"]).get().to_dict()
        result.append({'producttypedata':producttype,'product_data':product_pdtd,'productid':product.id})
    if request.method=="POST":
        image = request.FILES.get("photo")
        if image:
            path = "ProductPhoto/" + image.name
            st.child(path).put(image)
            u_url = st.child(path).get_url(None)
        data={"product_name":request.POST.get("product"),"producttype_id":request.POST.get("producttype"),"product_photo":u_url}
        db.collection("tbl_product").add(data)
        return redirect("webadmin:product")
    else:
        return render(request,"Admin/Product.html",{"producttype":pdt_data,"product":result})

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
    return render(request,"Admin/Servicebooking.html")

def complaints(request):
    return render(request,"Admin/Complaints.html")

def complaintreplay(request):
    return render(request,"Admin/Complaintreplay.html")

def viewproduct(request):
    return render(request,"Admin/Viewproduct.html")






        