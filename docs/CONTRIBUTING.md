# Contributing Guide

## 브랜치 네이밍 규칙

작업 목적을 식별할 수 있도록 다음 형식으로 브랜치 이름을 작성합니다.

feature/<description>

### 예시

- features/branch-naming
- features/commit-convention
- features/learning-notes

브랜치 이름은 소문자와 하이폰(-)을 사용합니다.

## PR 규칙
- PR 타이틀
  - 의미없는 문구나 내용이 충분히 담기지 않은 제목 금지
  - PR에 포함된 commit들이 무엇인지 충분히 알 수 있는 내용으로 작성
- PR 본문
  - 필수 항목(What/Why/How)
  - 이슈 링크
    - 이슈 최종 해결인 경우 - Closes #issue
    - 이슈 부분 해결인 경우 - Part of #issue
- 병합 조건 (branch protection rule로 이미 강제된 규칙)
  - main branch에 대한 직접적인 Push 제한
  - PR을 통한 Merge 원칙
  - 리뷰 1명 승인
