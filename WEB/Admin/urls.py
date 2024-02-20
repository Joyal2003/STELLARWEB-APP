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
    
  
    path('producttype/',views.producttype,name="producttype"), 
    path('delproducttype/<str:id>',views.delproducttype,name="delproducttype"),
    path('editproducttype/<str:id>',views.editproducttype,name="editproducttype"),
    
    path('product/',views.product,name="product"),
       
       
    path('admin/',views.admin,name="admin"),
    
      
         path('servicebooking/',views.servicebooking,name="sercivebooking"),
          path('complaints/',views.complaints,name="complaints"),
           path('complaintreplay/',views.complaintreplay,name="complaintreplay"),
            path('viewproduct/',views.viewproduct,name="viewproduct"),



     
]   