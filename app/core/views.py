"""
Core views for the app.
"""
from rest_framework.decorators import api_view
from rest_framework.response import Response


@api_view(['GET'])
def health_check(request):
    """Check the health of the API."""
    return Response({'healthy': True})
