// RUN: %target-swift-frontend -typecheck %s -debug-generic-signatures -requirement-machine-inferred-signatures=verify 2>&1 | %FileCheck %s

protocol P {
  associatedtype T : Q
}

protocol Q {
  associatedtype T : R

  var t: T { get }
}

protocol R {}

func takesR<T : R>(_: T) {}

class C<T : Q> : P {}

struct Outer<T : P> {
  // CHECK-LABEL: .Inner@
  // CHECK-NEXT: Generic signature: <T, U where T : C<U>, U : Q>
  struct Inner<U> where T : C<U> {
    func doStuff(_ u: U) {
      takesR(u.t)
    }
  }
}
