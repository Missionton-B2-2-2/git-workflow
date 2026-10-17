# Interactive Rebase 실습 기록

## 1. 실습 개요

- **참여자:** @jangsoopark-codyssey
- **작업 브랜치:** `feature/submission-index`
- **대상 파일:** `SUBMISSION.md`
- **목적:** 제출 인덱스 작성 과정에서 생성한 Commit 3개를 하나로 통합하여 History 정리
- **사용 명령어:** `git rebase -i HEAD~3`
- **적용 방식:** `squash` (2개 Commit을 첫 번째 Commit에 통합)
- **실습 범위:** 원격 Push 전 개인 Feature Branch

## 2. Rebase 이전 History

```text
cace3ba docs: submission evidence 추가
046952a docs: submission verification 추가
730590c docs: submission index 추가
f8725f4 Merge pull request #26 from Missionton-B2-2-2/feature/jangsoopark-conflict-resolution
```

기준 Commit은 `f8725f4`이며, 그 위에 `SUBMISSION.md`에 대한 Commit 3개가 존재하였습니다.

## 3. Rebase 수행 절차

다음 명령으로 최근 Commit 3개에 대해 Interactive Rebase를 실행하였습니다.

```bash
git rebase -i HEAD~3
```

Rebase 편집기에서 다음과 같이 설정하였습니다.

```text
pick 730590c docs: submission index 추가
squash 046952a docs: submission verification 추가
squash cace3ba docs: submission evidence 추가
```

첫 번째 Commit은 유지하고, 두 번째와 세 번째 Commit의 변경 이력을 첫 번째 Commit에 통합하였습니다.

실행 결과:

```text
[detached HEAD 44336dc] docs: submission index 추가
 1 file changed, 113 insertions(+)
 create mode 100644 SUBMISSION.md
Successfully rebased and updated refs/heads/feature/submission-index.
```

이후 최종 Commit 메시지를 명확하게 정리하기 위해 다음 명령을 실행하였습니다.

```bash
git commit --amend -m "docs: 제출 인덱스 및 협업 증빙 정리"
```

이에 따라 Squash 직후 Commit `44336dc`가 `a510ed6`으로 변경되었습니다.

## 4. Rebase 및 Commit 메시지 정리 이후 History

```text
a510ed6 docs: 제출 인덱스 및 협업 증빙 정리
f8725f4 Merge pull request #26 from Missionton-B2-2-2/feature/jangsoopark-conflict-resolution
d1cf60b docs: 두번째 충돌 해결 사례 추가
4eaf60c Merge pull request #24 from Missionton-B2-2-2/feature/jangsoopark-revert-practice
```

## 5. 전후 비교

| 항목 | 이전 | 이후 |
|---|---|---|
| 작업 브랜치 | `feature/submission-index` | `feature/submission-index` |
| 대상 Commit 수 | 3개 | 1개 |
| 작업 Commit Hash | `730590c`, `046952a`, `cace3ba` | `a510ed6` |
| 기준 Commit | `f8725f4` | `f8725f4` |
| 변경 대상 | `SUBMISSION.md` | `SUBMISSION.md` |
| 정리 방식 | 개별 Commit 유지 | Interactive Rebase의 `squash` |

`git rebase -i` 실행으로 3개의 Commit을 하나로 통합하였고, 이후 `git commit --amend`로 통합 Commit 메시지를 수정하였습니다. 최종 결과에서 `SUBMISSION.md`는 113줄이 추가된 하나의 Commit으로 기록됩니다.

## 6. 실습 결과 및 주의사항

- **결과:** Interactive Rebase를 통해 작업 Commit 3개를 하나로 통합하였습니다.
- **변경 이력:** Rebase는 Commit을 재작성하므로 통합된 Commit에는 새로운 Hash가 부여되었습니다.
- **기준 브랜치:** 기존 `main`의 기준 Commit `f8725f4`는 변경되지 않았습니다.
- **안전성:** 원격에 Push하지 않은 개인 Feature Branch에서 수행하여 공유 History를 재작성하지 않았습니다.
- **주의사항:** 이미 다른 팀원과 공유한 브랜치에 Rebase나 강제 Push를 적용할 때는 사전 협의가 필요합니다.

## 7. 관련 증빙

- 제출 인덱스: [`SUBMISSION.md`](../SUBMISSION.md)
- 작업 브랜치: [`feature/submission-index`](https://github.com/Missionton-B2-2-2/git-workflow/tree/feature/submission-index)
- Rebase 이전 Commit: `730590c`, `046952a`, `cace3ba`
- Rebase 이후 최종 Commit: `a510ed6`
