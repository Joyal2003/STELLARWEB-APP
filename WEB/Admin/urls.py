from django.urls import path,include
from Admin import views
app_name="webadmin"
urlpatterns = [
    path('district/',views.district,name="district"),
    path('editdistrict/<str:id>',views.editdistrict,name="editdistrict"),
    path('deldistrict/<str:id>',views.deldistrict,name="deldistrict"),

    path('Place/',views.Place,name="Place"),
    path('delplace/<str:id>',views.delplace,name="delplace"),
    path('editplace/<str:id>',views.editplace,name="editplace"),

    # path('servicerequest/',views.servicerequest,name="servicerequest"),
    
  
    path('producttype/',views.producttype,name="producttype"), 
    path('delproducttype/<str:id>',views.delproducttype,name="delproducttype"),
    path('editproducttype/<str:id>',views.editproducttype,name="editproducttype"),
    
    path('type/',views.types,name="types"),
       
       
    path('admin/',views.admin,name="admin"),
    path('homepage/',views.homepage,name="homepage"),
    
      
    path('servicebooking/',views.servicebooking,name="sercivebooking"),
    path('servicereplay/',views.servicereplay,name="servicereplay"),

          
           path('complaintreplay/',views.complaintreplay,name="complaintreplay"),
            

    path('accepted/<str:id>',views.accepted,name="accepted"),
    path('rejected<str:id>',views.rejected,name="rejected")

     
]   