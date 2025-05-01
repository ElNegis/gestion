from django.http import HttpResponseForbidden

class BlockMetadataMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        host= request.get_host()
        print(f"Middleware: Recibida solicitud con Host: {host}")
        if "169.254.169.254" in host:
            print("BLOQUEADO")
            return HttpResponseForbidden("Access to metadata is not allowed.")

        return self.get_response(request)
