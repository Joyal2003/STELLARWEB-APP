from django.urls import path,include
from Guest import views
app_name="webguest"
urlpatterns = [
  path('login/',views.login,name="login"),
  path('userreg/',views.userreg,name="userreg"),
  path('ajaxplace/',views.ajaxplace,name="ajaxplace"),
  path('',views.index,name="index"),
  path('fpassword/',views.fpassword,name="fpassword"),
]