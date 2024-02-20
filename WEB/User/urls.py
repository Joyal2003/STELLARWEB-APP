from django.urls import path,include
from User import views
app_name ="webuser"
urlpatterns = [
  path("homepage/",views.homepage,name="homepage"),
  path("Myprofile/",views.Myprofile,name="Myprofile"),
  path("Editprofile/",views.Editprofile,name="Editprofile"),
  path("changepassword/",views.changepassword,name="changepassword"),
   path('complaint/',views.complaint,name="complaint"),
    path('products/',views.products,name="products"),
     path('review/',views.review,name="review"),
      path('changepassword/',views.changepassword,name="changepassword"),



]