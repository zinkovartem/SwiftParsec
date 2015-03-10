#![feature(plugin)]
#![plugin(regex_macros)]
extern crate regex;
use regex::Regex;
extern crate core;
use core::str::FromStr;

trait Parser<T> {
    fn parse(&self, s:&str) -> Option<(T,usize)>;
}

struct RxParser {
    rx:Regex
}

impl RxParser {
    fn new(pattern:&str) -> Self {
        let rx = match Regex::new(pattern) {
            Ok(re) => re,
            Err(err) => panic!("Error: {}", err),
        };
        return RxParser {rx: rx};
    }
}

impl Parser<String> for RxParser {
    fn parse(&self, s:&str) -> Option<(String,usize)> {
        if let Some(uv) = self.rx.find(s) {
            let value : String = String::from_str(&s[uv.0..uv.1]);
            return Some((value, uv.1));
        }
        return None;
    }
}


struct IntParser;

impl Parser<i64> for IntParser {
    fn parse(&self, s:&str) -> Option<(i64,usize)> {
        let rx = regex!(r"^[+-]?[0-9]+");
        if let Some(uv) = rx.find(s) {
            let value = i64::from_str(&s[uv.0..uv.1]).unwrap();
            return Some((value, uv.1));
        }
        return None;
    }
}

fn main() {
  let ipt = "Hello world!";

  let parser = RxParser::new(r"^Hello");
  if let Some(res) = parser.parse(ipt) {
      let rem = &ipt[res.1..];
      println!("Result: {}  Remainder: {}", res.0, rem);
  } else {
      println!("No match");
  }
}
