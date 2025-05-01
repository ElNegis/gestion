from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet, AssignRoleView, RemoveRoleView, LoginView, LogoutView, LogsSeguridadView,LogsAplicativosView

router = DefaultRouter()
router.register(r'users', UserViewSet, basename='user')

urlpatterns = [
    path('', include(router.urls)),
    path('auth/login/', LoginView.as_view(), name='login'),
    path('auth/logout/', LogoutView.as_view(), name='logout'),
    path('roles/assign/', AssignRoleView.as_view(), name='assign-role'),
    path('roles/remove/', RemoveRoleView.as_view(), name='remove-role'),
    path('logs/aplicativos/', LogsAplicativosView.as_view(), name='logs'),
    path('logs/seguridad/', LogsSeguridadView.as_view(), name='logs'),

]
