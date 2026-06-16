#!/bin/bash

# 에러 발생 시 스크립트 중단
set -e

echo "🚀 데이터 분석가/엔지니어 전용 Mac 초기 세팅을 시작합니다..."

# 1. Homebrew 설치 확인 및 설치
if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew가 없습니다. 설치를 시작합니다..."
    /bin/bash -c "$(curl -fsSL https://githubusercontent.com)"
    
    # M시리즈 맥 환경 초기 환경변수 설정
    if [[ "$(uname -m)" == "arm64" ]]; then
        (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

brew update

# 2. 터미널 기반 유틸리티 설치 함수
install_brew_formula() {
    if brew list --formula | grep -q "^$1$"; then
        echo "✅ $1 은(는) 이미 설치되어 있어 건너넙니다."
    else
        echo "📥 $1 설치 중..."
        brew install "$1"
    fi
}

# 3. GUI 애플리케이션 설치 함수
install_brew_cask() {
    if brew list --cask | grep -q "^$1$"; then
        echo "✅ $1 은(는) 이미 설치되어 있어 건너넙니다."
    else
        echo "📥 $1 설치 중..."
        brew install --cask "$1"
    fi
}

echo "------------------------------------------"
echo "📦 1. CLI 도구 설치"
echo "------------------------------------------"
install_brew_formula "git"
install_brew_formula "jq"           # JSON 데이터 파싱용 유틸리티
install_brew_formula "gemini-cli"   # 구글 제미나이 CLI 도구 추가
install_brew_formula "mas"          # 맥 앱스토어 다운로드용 CLI 추가

echo "------------------------------------------"
echo "🖥️ 2. 데이터 및 개발 애플리케이션 설치"
echo "------------------------------------------"
install_brew_cask "datagrip"             # JetBrains DataGrip
install_brew_cask "dbeaver-community"    # DBeaver 무료 DB 툴
install_brew_cask "visual-studio-code"   # VS Code

# [주석 처리 완료] Docker Desktop은 필요할 때 아래 주석(#)을 지우고 실행하세요.
# install_brew_cask "docker"               

echo "------------------------------------------"
echo "💡 3. 생산성 및 UI/커스텀 유틸리티 설치"
echo "------------------------------------------"
install_brew_cask "anthropic-claude"     # Claude 데스크톱
install_brew_cask "obsidian"             # Obsidian 노트 앱
install_brew_cask "rectangle"            # Rectangle 화면 분할 앱
install_brew_cask "slack"                # 슬랙
install_brew_cask "notion"               # 노션

# 새로 추가된 UI/생산성 커스텀 앱 리스트
install_brew_cask "dockdoor"             # Dockdoor (창 실시간 미리보기)
install_brew_cask "launchie"             # Launchie (런치패드 대체 무료 앱)
install_brew_cask "linearmouse"          # LinearMouse (마우스 가속도 개별 설정)

echo "------------------------------------------"
echo "🍏 4. 맥 앱스토어 전용 애플리케이션 설치"
echo "------------------------------------------"
# mas 명령어를 이용해 앱스토어 전용 앱들을 백그라운드 자동 다운로드합니다.
echo "📥 Dropover 설치 중..."
mas install 1355679052 || echo "⚠️ Dropover 설치 실패 (앱스토어 로그인을 확인하세요)"

echo "📥 Folder Hub 설치 중..."
mas install 1616773227 || echo "⚠️ Folder Hub 설치 실패"

echo "📥 RunCat 설치 중..."
mas install 1429033973 || echo "⚠️ RunCat 설치 실패"

echo "📥 Googly Eyes 설치 중..."
mas install 1534015668 || echo "⚠️ Googly Eyes 설치 실패"

echo "------------------------------------------"
echo "✨ 모든 데이터 및 유틸리티 환경 세팅이 성공적으로 완료되었습니다!"
echo "------------------------------------------"
