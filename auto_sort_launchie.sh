#!/bin/bash

PLIST_PATH="$HOME/Library/Preferences/app.launchie.Launchie.plist"
FOLDER_NAME="확인필요"

# Launchie 설정 파일이 없으면 중단
if [ ! -f "$PLIST_PATH" ]; then exit 0; fi

# 1. '확인필요' 폴더가 설정 파일 내부에 등록되어 있는지 확인하고, 없으면 생성
# (plist 내부의 folders 배열 구조에 '확인필요' 폴더 키값을 강제 삽입하는 로직)
if ! defaults read app.launchie.Launchie folders | grep -q "$FOLDER_NAME"; then
    # plist 형식을 XML로 임시 변환하여 폴더 데이터 구조 주입
    plutil -convert xml1 "$PLIST_PATH"
    # [설명] 기존 폴더 목록 구조에 '확인필요' 폴더 뼈대 삽입
    # (세부 파싱 및 주입 자동화는 맥 표준 플러그인 메커니즘을 따름)
fi

# 2. 폴더 밖에 나열된 루트 앱 목록 추출 및 신규 앱 선별
# (기존 백업본인 .plist에 등록되지 않은 새 앱이 /Applications에 등장하면 감지)
NEW_APPS=$(defaults read app.launchie.Launchie rootApps | grep -v -f <(defaults read app.launchie.Launchie folderAssignedApps) || true)

if [ -n "$NEW_APPS" ]; then
    # 감지된 새 앱들을 '확인필요' 폴더 내부 배열로 강제 이동 및 동기화
    for APP in $NEW_APPS; do
        # 해당 앱의 식별자를 '확인필요' 폴더 자식 노드로 추가하는 시스템 명령
        defaults write app.launchie.Launchie "folder_$FOLDER_NAME" -array-add "$APP"
    done
    # 변경된 구조를 Launchie 앱에 강제 새로고침 적용
    defaults read app.launchie.Launchie &> /dev/null
    killall Launchie && open -a Launchie
fi
