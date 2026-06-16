# mac-setup
새로운 맥북을 세팅하거나 포맷했을 때, 개발 환경과 필수 애플리케이션들을 터미널 명령어 한 줄로 자동 설치해 주는 개인용 환경설정 저장소입니다.

## 한 줄 설치 명령어

새 컴퓨터에서 터미널(Terminal) 앱을 열고 아래 명령어를 입력합니다. 
`{github-username}` 자리에는 본인의 실제 깃허브 계정 아이디를 입력해야 합니다.
`{github-reponame}` 자리에는 install.sh 파일이 들어있는 레포지토리 이름을 입력해야 합니다.

```bash
curl -fsSL "https://githubusercontent.com/{github-username}/{github-reponame}/main/install.sh" | bash
```

* **실행 전 필수 체크**: 맥북 App Store 앱을 열고 본인 애플 ID로 로그인하세요. 로그인이 안되면 앱스토어 전용 앱(RunCat 등) 설치가 실패합니다. 
* **설치 도중 강제 중단**: 터미널 창에서 `Control` + `C` 를 누르면 즉시 안전하게 멈춥니다.

---

## 유용한 관리 및 확인 명령어

설치가 끝난 후 프로그램들이 정상적으로 들어왔는지 터미널에서 확인하는 명령어 목록입니다.

### 1. 일반 애플리케이션 설치 확인 (Cask)
DataGrip, Claude, VS Code 등 일반 앱들의 목록을 조회합니다.
```bash
brew list --cask
```

### 2. 터미널 전용 도구 설치 확인 (Formula)
Git, JQ, Node 등 터미널 기반 도구들을 조회합니다.
```bash
brew list --formula
```

### 3. 맥 앱스토어 전용 앱 설치 확인 (MAS)
RunCat, Dropover 등 애플 공식 앱스토어를 통해 설치된 앱들을 조회합니다.
```bash
mas list
```

---

## 보안 파일 관리 가이드 (.gitignore 규칙)

비밀번호나 API 토큰 정보가 깃허브에 유출되는 것을 막기 위해, 실제 비밀번호는 내 컴퓨터 로컬 환경에 `.env` 파일을 따로 만들어 관리합니다.

1. `.gitignore` 규칙에 의해 `.env` 파일은 깃허브 업로드 대상에서 제외됩니다.
2. 깃허브에는 실제 패스워드를 지운 양식 파일인 `.env.example`만 올려서 항목을 관리합니다.

*실수로 비밀번호가 적힌 `.env` 파일이 깃허브 서버에 올라갔을 때의 긴급 삭제 명령어:*
```bash
git rm --cached .env
git commit -m "chore: 보안 파일 추적 제외"
git push origin main
```

