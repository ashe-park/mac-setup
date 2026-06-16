#!/bin/bash

echo "🚀 에러 요소를 제거한 Mac 초기 세팅 재시작..."

# 1. Homebrew 설치 확인 및 설치
if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew가 없습니다. 설치를 시작합니다..."
    /bin/bash -c "$(curl -fsSL https://githubusercontent.com)"
    
    if [[ "$(uname -m)" == "arm64" ]]; then
        (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

brew update

# 2. 터미널 기반 유틸리티 설치 함수 (에러 안전 조치)
install_brew_formula() {
    if brew list --formula | grep -q "^$1$"; then
        echo "✅ $1 은(는) 이미 설치되어 있어 건너넙니다."
    else
        echo "📥 $1 설치 중..."
        brew install "$1" || echo "⚠️ $1 설치 실패 (건너뜀)"
    fi
}

# 3. GUI 애플리케이션 설치 함수 (에러 안전 조치)
install_brew_cask() {
    if brew list --cask | grep -q "^$1$"; then
        echo "✅ $1 은(는) 이미 설치되어 있어 건너넙니다."
    else
        echo "📥 $1 설치 중..."
        brew install --cask "$1" || echo "⚠️ $1 설치 실패 (건너뜀)"
    fi
}

echo "------------------------------------------"
echo "📦 1. CLI 도구 설치"
echo "------------------------------------------"
install_brew_formula "git"
install_brew_formula "jq"           # JSON 데이터 파싱용 유틸리티
install_brew_formula "mas"          # 맥 앱스토어 다운로드용 CLI
install_brew_formula "node"         # gemini-cli 구동을 위한 필수 노드 설치

# [교정] gemini-cli는 npm을 통해 글로벌 설치하는 것이 공식 표준입니다.
if ! command -v gemini &> /dev/null; then
    echo "📥 gemini-cli 글로벌 설치 중..."
    npm install -g @google/gemini-cli || echo "⚠️ gemini-cli 설치 실패"
else
    echo "✅ gemini-cli가 이미 존재합니다."
fi

echo "------------------------------------------"
echo "🖥️ 2. 데이터 및 개발 애플리케이션 설치"
echo "------------------------------------------"
install_brew_cask "datagrip"             # JetBrains DataGrip
install_brew_cask "dbeaver-community"    # DBeaver 무료 DB 툴
install_brew_cask "visual-studio-code"   # VS Code

echo "------------------------------------------"
echo "💡 3. 생산성 및 UI/커스텀 유틸리티 설치"
echo "------------------------------------------"
install_brew_cask "anthropic-claude"     # Claude 데스크톱
install_brew_cask "obsidian"             # Obsidian 노트 앱
install_brew_cask "rectangle"            # Rectangle 화면 분할 앱
# --- Rectangle 설정 자동 복사 코드 ---
echo "⚙️ Rectangle 단축키 설정을 적용합니다..."
mkdir -p ~/Library/Preferences
# 1. 현재 실행 중인 스크립트의 URL 주소를 역추적하여 깃허브 아이디 자동 추출
if [ -n "$BASH_SOURCE" ]; then
    # curl 원격 실행 시 주소 파싱
    GITHUB_USER=$(echo "$BASH_SOURCE" | cut -d'/' -f4)
else
    # 예외 상황 대비 기본값 세팅용 (추출 실패 시 기본 계정명 입력)
    GITHUB_USER="본인의_실제_깃허브_아이디"
fi
# 2. 추출한 변수($GITHUB_USER)를 주소에 자동으로 주입하여 다운로드
curl -fsSL "https://githubusercontent.com/{GITHUB_USER}/mac-setup/main/com.knollsoft.Rectangle.plist" -o ~/Library/Preferences/com.knollsoft.Rectangle.plist
defaults read com.knollsoft.Rectangle &> /dev/null

install_brew_cask "slack"                # 슬랙
install_brew_cask "notion"               # 노션
install_brew_cask "dockdoor"             # Dockdoor (창 실시간 미리보기)
install_brew_cask "launchie"             # Launchie (런치패드 대체 무료 앱)
install_brew_cask "linearmouse"          # LinearMouse (마우스 가속도 개별 설정)

echo "------------------------------------------"
echo "🍏 4. 맥 앱스토어 전용 애플리케이션 설치"
echo "------------------------------------------"
# mas가 정상 설치된 경우에만 앱스토어 다운로드를 시도합니다.
if command -v mas &> /dev/null; then
    echo "📥 Dropover 설치 중..."
    mas install 1355679052 || echo "⚠️ Dropover 설치 보류 (앱스토어 로그인을 확인하세요)"

    echo "📥 Folder Hub 설치 중..."
    mas install 1616773227 || echo "⚠️ Folder Hub 설치 보류"

    echo "📥 RunCat 설치 중..."
    mas install 1429033973 || echo "⚠️ RunCat 설치 보류"

    echo "📥 Googly Eyes 설치 중..."
    mas install 1534015668 || echo "⚠️ Googly Eyes 설치 보류"
fi

echo "------------------------------------------"
echo "✨ 전체 수정 버전 환경 세팅 프로세스 완료!"
echo "------------------------------------------"
