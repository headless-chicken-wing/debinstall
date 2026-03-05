import http.server
import os
from urllib.parse import unquote
from pathlib import Path

PORT = 8000
IMAGE_EXTS = {'.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'}

class ImageGalleryHandler(http.server.SimpleHTTPRequestHandler):
    def list_images(self):
        files = [f for f in os.listdir('.') if Path(f).suffix.lower() in IMAGE_EXTS]
        files.sort()
        items = '\n'.join(
            f'<a href="{f}" target="_blank"><img src="{f}" alt="{f}" style="width:150px; margin:5px; border:1px solid #ccc;"></a>'
            for f in files
        )
        return f"""<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>Image Gallery</title></head>
<body style="font-family:sans-serif; text-align:center;">
<h1>Image Gallery</h1>
<div style="display:flex; flex-wrap:wrap; justify-content:center;">{items}</div>
</body>
</html>"""

    def do_GET(self):
        path = unquote(self.path)
        if path == '/' or path == '/index.html':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            html = self.list_images()
            self.wfile.write(html.encode('utf-8'))
        else:
            super().do_GET()

if __name__ == '__main__':
    print(f"Serving at http://localhost:{PORT}")
    http.server.HTTPServer(('', PORT), ImageGalleryHandler).serve_forever()
