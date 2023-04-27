
upweb:
	flutter build web --web-renderer canvaskit --dart-define=FLUTTER_WEB_CANVASKIT_URL=./canvaskit/
	#flutter build web --web-renderer html
	cp -r build/web/* ~/github/chatgpt.github.io
	cd ~/github/chatgpt.github.io && git add . && git commit -m "update" && git push origin main

