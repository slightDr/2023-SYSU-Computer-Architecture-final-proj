; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -disable-output -print-mustexecute %s 2>&1 | FileCheck %s

; In general the CFG below is easily simplified but this is useful for
; pass ordering issue elimination.
define i1 @const_cond(i32 %high) {
; CHECK-LABEL: @const_cond(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ] ; (mustexec in: loop)
; CHECK-NEXT:    br i1 true, label [[NEXT:%.*]], label [[NEVER1:%.*]] ; (mustexec in: loop)
; CHECK:       next:
; CHECK-NEXT:    br i1 false, label [[NEVER2:%.*]], label [[BACKEDGE]] ; (mustexec in: loop)
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1 ; (mustexec in: loop)
; CHECK-NEXT:    [[EXIT_TEST:%.*]] = icmp slt i32 [[IV]], [[HIGH:%.*]] ; (mustexec in: loop)
; CHECK-NEXT:    br i1 [[EXIT_TEST]], label [[LOOP]], label [[EXIT:%.*]] ; (mustexec in: loop)
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
; CHECK:       never1:
; CHECK-NEXT:    unreachable
; CHECK:       never2:
; CHECK-NEXT:    unreachable
;
entry:
  br label %loop

loop:
  %iv = phi i32 [0, %entry], [%iv.next, %backedge]
  br i1 true, label %next, label %never1
next:
  br i1 false, label %never2, label %backedge
backedge:
  %iv.next = add nsw nuw i32 %iv, 1
  %exit.test = icmp slt i32 %iv, %high
  br i1 %exit.test, label %loop, label %exit

exit:
  ret i1 false
never1:
  unreachable
never2:
  unreachable
}

