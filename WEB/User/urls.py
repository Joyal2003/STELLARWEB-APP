from django.urls import path,include
from User import views
app_name ="webuser"
urlpatterns = [
  path("homepage/",views.homepage,name="homepage"),
  path("Myprofile/",views.Myprofile,name="Myprofile"),
  path("Editprofile/",views.Editprofile,name="Editprofile"),
   path('servicerequest/',views.servicerequest,name="servicerequest"),
  path('feedback/',views.feedback,name="feedback"),
  path('changepassword/',views.changepassword,name="changepassword"),
  path('complaint/',views.complaint,name="complaint"),
  path('myservice/',views.myservice,name="myservice")


]