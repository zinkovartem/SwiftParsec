class FollowedBy<T1 : Parser, T2 : Parser> : Parser {
  let first : T1
  let second: T2

  init(first:T1, second:T2) {
    self.first = first
    self.second = second
  }

  typealias R1 = T1.TargetType
  typealias R2 = T2.TargetType
  typealias TargetType = (R1,R2)

  func parse<S: CharStream>(inout stream: S) -> TargetType? {
    let reset = stream
    if let a = first.parse(&stream) {
      if let b = second.parse(&stream) {
        return (a,b)
      }
    }
    stream = reset
    return nil
  }
}

class FollowedByFirst<T1 : Parser, T2 : Parser> : Parser {
  let helper: FollowedBy<T1,T2>

  init (first:T1, second:T2) {
    helper = FollowedBy(first:first, second:second)
  }

  typealias TargetType = T1.TargetType

  func parse<S: CharStream>(inout stream: S) -> TargetType? {
    if let (a,b) = helper.parse(&stream) {
      return a
    }
    return nil
  }
}

class FollowedBySecond<T1 : Parser, T2 : Parser> : Parser {
  let helper: FollowedBy<T1,T2>

  init (first:T1, second:T2) {
    helper = FollowedBy(first:first, second:second)
  }

  typealias TargetType = T2.TargetType

  func parse<S: CharStream>(inout stream: S) -> TargetType? {
    if let (a,b) = helper.parse(&stream) {
      return b
    }
    return nil
  }
}



infix operator >> {associativity left precedence 140}
func >><T1: Parser, T2: Parser>(first: T1, second: T2) -> FollowedBy<T1,T2> {
  return FollowedBy(first: first, second: second)
}

infix operator ->> {associativity left precedence 140}
func ->><T1: Parser, T2: Parser>(first: T1, second: T2) -> FollowedByFirst<T1,T2> {
  return FollowedByFirst(first: first, second: second)
}

infix operator >>- {associativity left precedence 140}
func >>-<T1: Parser, T2: Parser>(first: T1, second: T2) -> FollowedBySecond<T1,T2> {
  return FollowedBySecond(first: first, second: second)
}