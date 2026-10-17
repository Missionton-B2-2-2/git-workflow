# Git Revert

## 1. 개요

git revert는 특정 Commit의 변경 사항을 취소하는 새로운 Commit을 생성하는 명령어입니다.

기존 Commit을 삭제하거나 History를 재작성하지 않기 때문에 이미 원격 저장소에 Push된 변경 사항을 안전하게 취소할 때 사용할 수 있습니다.

## 2. 사용 방법

```bash
git revert <commit-hash>
```

지정한 Commit의 변경 사항을 반대로 적용하고 새로운 Commit을 생성합니다.

## 3. Git Reset과의 차이

|구분|git revert|git reset|
|---|---|---|
기존 Commit|History에 유지|현재 브랜치 History에서 제외 가능|
|새로운 Commit|생성|생성하지 않음|
History 재작성|없음|브랜치 참조 이동|
|주요 용도|공유된 변경 취소|로컬 Commit 취소 및 상태 복원|

## 4. 실습

<details>

<summary>[Screenshot]Git Revert 실습 증빙</summary>

![Git Revert 실습 증빙](/jangsoopark-codyssey/assets/images/git-revert-practice-evidence.png)

</details>

### 4.1 초기 Commit 생성

실습 파일 revert-demo.txt를 생성하고 다음 내용을 작성하였습니다.

```plaintext
Git Revert Practice

Status: Initial version
Description: Practice reverting a pushed commit.
```

Commit Hash: 7d4f8b9

### 4.2 잘못된 Commit 생성

실습 파일의 내용을 의도적으로 잘못 수정한 뒤 원격 저장소에 Push 했습니다.

```plaintext
Git Revert Practice

Status: Incorrect version
Description: This change was pushed by mistake.
```

Commit Hash: 29c8b21

### 4.3 Git Revert 실행

```bash
git revert 29c8b21
```

실행 결과:
```plaintext
[feature/jangsoopark-revert-practice da7e3b8] Revert "docs: git revert 실험을 위하여 의도적으로 절못된 콘텐츠 추가"
 1 file changed, 2 insertions(+), 2 deletions(-)
```

Revert Commit Hash: da7e3b8

### 4.4 결과 확인

```bash
git log -3 --oneline --graph
```

```plaintext
da7e3b8 Revert "docs: git revert 실험을 위하여 의도적으로 절못된 콘텐츠 추가"
29c8b21 docs: git revert 실험을 위하여 의도적으로 절못된 콘텐츠 추가
7d4f8b9 docs: git revert 실험용 파일 추가
```

실습 파일을 확인한 결과, 잘못된 수정 이전의 내용으로 복구되었습니다.
이후 다음 명령어로 원격 저장소에 반영했습니다.

```bash
git push origin feature/jangsoopark-revert-practice
```

### 4.5 변경 사항 복구 검증

초기 Commit과 Revert Commit의 파일 내용을 비교했습니다.

```bash
git diff 7d4f8b9 da7e3b8 -- jangsoopark-codyssey/src/practice/revert-demo.txt
```

출력 결과가 없으므로 두 Commit에서 해당 파일의 내용이 동일함을 확인했습니다.
또한 git show --stat으로 잘못된 Commit과 Revert Commit의 변경 이력을 확인 했습니다.

## 5. 주의사항

- git revert는 기존 Commit을 삭제하지 않습니다.
- Revert 대상 Commit 이후의 변경 사항에 따라 Conflict가 발생할 수 있습니다.
- 공유 브랜치에서 이미 Push 된 변경을 취소할 때 git reset보다 적합한 경우가 많습니다.
- Revert Commit도 일반적인 Commit과 마찬가지로 원격 저장소에 Push해야 합니다.

## 6. 정리

이번 실습에서는 원격 저장소에 Push 된 잘못된 Commit을 git revert 로 취소했습니다.

기존 Commit은 History에 유지되었으며, 이를 취소하는 새로운 Commit이 생성된 것을 확인했습니다.