
upweb:
	flutter build web --web-renderer canvaskit
	#flutter build web --web-renderer html
	cp -r build/web/* ~/github/chatgpt.github.io
	cd ~/github/chatgpt.github.io && git add . && git commit -m "update" && git push origin main

