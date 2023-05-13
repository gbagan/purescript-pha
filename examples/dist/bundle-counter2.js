(() => {
  // output-es/runtime.js
  function fail() {
    throw new Error("Failed pattern match");
  }

  // output-es/Data.Functor/foreign.js
  var arrayMap = function(f) {
    return function(arr) {
      var l = arr.length;
      var result = new Array(l);
      for (var i = 0; i < l; i++) {
        result[i] = f(arr[i]);
      }
      return result;
    };
  };

  // output-es/Control.Apply/index.js
  var identity = (x) => x;

  // output-es/Data.Show/foreign.js
  var showIntImpl = function(n) {
    return n.toString();
  };

  // output-es/Data.Ordering/index.js
  var $Ordering = (tag) => ({ tag });
  var LT = /* @__PURE__ */ $Ordering("LT");
  var GT = /* @__PURE__ */ $Ordering("GT");
  var EQ = /* @__PURE__ */ $Ordering("EQ");

  // output-es/Data.Maybe/index.js
  var $Maybe = (tag, _1) => ({ tag, _1 });
  var Nothing = /* @__PURE__ */ $Maybe("Nothing");
  var Just = (value0) => $Maybe("Just", value0);

  // output-es/Data.Either/index.js
  var $Either = (tag, _1) => ({ tag, _1 });
  var Left = (value0) => $Either("Left", value0);
  var Right = (value0) => $Either("Right", value0);

  // output-es/Effect/foreign.js
  var pureE = function(a) {
    return function() {
      return a;
    };
  };

  // output-es/Effect/index.js
  var applyEffect = {
    apply: (f) => (a) => () => {
      const f$p = f();
      const a$p = a();
      return applicativeEffect.pure(f$p(a$p))();
    },
    Functor0: () => functorEffect
  };
  var applicativeEffect = { pure: pureE, Apply0: () => applyEffect };
  var functorEffect = {
    map: (f) => (a) => () => {
      const a$p = a();
      return f(a$p);
    }
  };

  // output-es/Control.Monad.Rec.Class/index.js
  var $Step = (tag, _1) => ({ tag, _1 });
  var Loop = (value0) => $Step("Loop", value0);
  var Done = (value0) => $Step("Done", value0);

  // output-es/Data.Foldable/index.js
  var traverse_ = (dictApplicative) => {
    const $0 = dictApplicative.Apply0();
    const map = $0.Functor0().map;
    return (dictFoldable) => (f) => dictFoldable.foldr((x) => {
      const $1 = f(x);
      return (b) => $0.apply(map((v) => identity)($1))(b);
    })(dictApplicative.pure());
  };
  var for_ = (dictApplicative) => {
    const traverse_1 = traverse_(dictApplicative);
    return (dictFoldable) => {
      const $0 = traverse_1(dictFoldable);
      return (b) => (a) => $0(a)(b);
    };
  };
  var foldableMaybe = {
    foldr: (v) => (v1) => (v2) => {
      if (v2.tag === "Nothing") {
        return v1;
      }
      if (v2.tag === "Just") {
        return v(v2._1)(v1);
      }
      fail();
    },
    foldl: (v) => (v1) => (v2) => {
      if (v2.tag === "Nothing") {
        return v1;
      }
      if (v2.tag === "Just") {
        return v(v1)(v2._1);
      }
      fail();
    },
    foldMap: (dictMonoid) => {
      const mempty = dictMonoid.mempty;
      return (v) => (v1) => {
        if (v1.tag === "Nothing") {
          return mempty;
        }
        if (v1.tag === "Just") {
          return v(v1._1);
        }
        fail();
      };
    }
  };

  // output-es/Data.Tuple/index.js
  var $Tuple = (_1, _2) => ({ tag: "Tuple", _1, _2 });

  // output-es/Data.List.Types/index.js
  var $List = (tag, _1, _2) => ({ tag, _1, _2 });
  var Nil = /* @__PURE__ */ $List("Nil");

  // output-es/Data.List/index.js
  var reverse = /* @__PURE__ */ (() => {
    const go = (go$a0$copy) => (go$a1$copy) => {
      let go$a0 = go$a0$copy, go$a1 = go$a1$copy, go$c = true, go$r;
      while (go$c) {
        const v = go$a0, v1 = go$a1;
        if (v1.tag === "Nil") {
          go$c = false;
          go$r = v;
          continue;
        }
        if (v1.tag === "Cons") {
          go$a0 = $List("Cons", v1._1, v);
          go$a1 = v1._2;
          continue;
        }
        fail();
      }
      return go$r;
    };
    return go(Nil);
  })();

  // output-es/Data.Traversable/foreign.js
  var traverseArrayImpl = function() {
    function array1(a) {
      return [a];
    }
    function array2(a) {
      return function(b) {
        return [a, b];
      };
    }
    function array3(a) {
      return function(b) {
        return function(c) {
          return [a, b, c];
        };
      };
    }
    function concat2(xs) {
      return function(ys) {
        return xs.concat(ys);
      };
    }
    return function(apply) {
      return function(map) {
        return function(pure) {
          return function(f) {
            return function(array) {
              function go(bot, top) {
                switch (top - bot) {
                  case 0:
                    return pure([]);
                  case 1:
                    return map(array1)(f(array[bot]));
                  case 2:
                    return apply(map(array2)(f(array[bot])))(f(array[bot + 1]));
                  case 3:
                    return apply(apply(map(array3)(f(array[bot])))(f(array[bot + 1])))(f(array[bot + 2]));
                  default:
                    var pivot = bot + Math.floor((top - bot) / 4) * 2;
                    return apply(map(concat2)(go(bot, pivot)))(go(pivot, top));
                }
              }
              return go(0, array.length);
            };
          };
        };
      };
    };
  }();

  // output-es/Data.CatQueue/index.js
  var $CatQueue = (_1, _2) => ({ tag: "CatQueue", _1, _2 });
  var uncons = (uncons$a0$copy) => {
    let uncons$a0 = uncons$a0$copy, uncons$c = true, uncons$r;
    while (uncons$c) {
      const v = uncons$a0;
      if (v._1.tag === "Nil") {
        if (v._2.tag === "Nil") {
          uncons$c = false;
          uncons$r = Nothing;
          continue;
        }
        uncons$a0 = $CatQueue(reverse(v._2), Nil);
        continue;
      }
      if (v._1.tag === "Cons") {
        uncons$c = false;
        uncons$r = $Maybe("Just", $Tuple(v._1._1, $CatQueue(v._1._2, v._2)));
        continue;
      }
      fail();
    }
    return uncons$r;
  };

  // output-es/Data.CatList/index.js
  var $CatList = (tag, _1, _2) => ({ tag, _1, _2 });
  var CatNil = /* @__PURE__ */ $CatList("CatNil");
  var link = (v) => (v1) => {
    if (v.tag === "CatNil") {
      return v1;
    }
    if (v1.tag === "CatNil") {
      return v;
    }
    if (v.tag === "CatCons") {
      return $CatList("CatCons", v._1, $CatQueue(v._2._1, $List("Cons", v1, v._2._2)));
    }
    fail();
  };
  var foldr = (k) => (b) => (q) => {
    const foldl = (foldl$a0$copy) => (foldl$a1$copy) => (foldl$a2$copy) => {
      let foldl$a0 = foldl$a0$copy, foldl$a1 = foldl$a1$copy, foldl$a2 = foldl$a2$copy, foldl$c = true, foldl$r;
      while (foldl$c) {
        const v = foldl$a0, v1 = foldl$a1, v2 = foldl$a2;
        if (v2.tag === "Nil") {
          foldl$c = false;
          foldl$r = v1;
          continue;
        }
        if (v2.tag === "Cons") {
          foldl$a0 = v;
          foldl$a1 = v(v1)(v2._1);
          foldl$a2 = v2._2;
          continue;
        }
        fail();
      }
      return foldl$r;
    };
    const go = (go$a0$copy) => (go$a1$copy) => {
      let go$a0 = go$a0$copy, go$a1 = go$a1$copy, go$c = true, go$r;
      while (go$c) {
        const xs = go$a0, ys = go$a1;
        const v = uncons(xs);
        if (v.tag === "Nothing") {
          go$c = false;
          go$r = foldl((x) => (i) => i(x))(b)(ys);
          continue;
        }
        if (v.tag === "Just") {
          go$a0 = v._1._2;
          go$a1 = $List("Cons", k(v._1._1), ys);
          continue;
        }
        fail();
      }
      return go$r;
    };
    return go(q)(Nil);
  };
  var uncons2 = (v) => {
    if (v.tag === "CatNil") {
      return Nothing;
    }
    if (v.tag === "CatCons") {
      return $Maybe("Just", $Tuple(v._1, (v._2._1.tag === "Nil" ? v._2._2.tag === "Nil" : false) ? CatNil : foldr(link)(CatNil)(v._2)));
    }
    fail();
  };

  // output-es/Control.Monad.Free/index.js
  var $Free = (_1, _2) => ({ tag: "Free", _1, _2 });
  var $FreeView = (tag, _1, _2) => ({ tag, _1, _2 });
  var toView = (toView$a0$copy) => {
    let toView$a0 = toView$a0$copy, toView$c = true, toView$r;
    while (toView$c) {
      const v = toView$a0;
      if (v._1.tag === "Return") {
        const v2 = uncons2(v._2);
        if (v2.tag === "Nothing") {
          toView$c = false;
          toView$r = $FreeView("Return", v._1._1);
          continue;
        }
        if (v2.tag === "Just") {
          toView$a0 = (() => {
            const $0 = v2._1._1(v._1._1);
            return $Free($0._1, link($0._2)(v2._1._2));
          })();
          continue;
        }
        fail();
      }
      if (v._1.tag === "Bind") {
        toView$c = false;
        toView$r = $FreeView(
          "Bind",
          v._1._1,
          (a) => {
            const $0 = v._1._2(a);
            return $Free($0._1, link($0._2)(v._2));
          }
        );
        continue;
      }
      fail();
    }
    return toView$r;
  };
  var runFreeM = (dictFunctor) => (dictMonadRec) => {
    const Monad0 = dictMonadRec.Monad0();
    const map2 = Monad0.Bind1().Apply0().Functor0().map;
    const pure1 = Monad0.Applicative0().pure;
    return (k) => dictMonadRec.tailRecM((f) => {
      const v = toView(f);
      if (v.tag === "Return") {
        return map2(Done)(pure1(v._1));
      }
      if (v.tag === "Bind") {
        return map2(Loop)(k(dictFunctor.map(v._2)(v._1)));
      }
      fail();
    });
  };
  var freeMonad = { Applicative0: () => freeApplicative, Bind1: () => freeBind };
  var freeFunctor = { map: (k) => (f) => freeBind.bind(f)((x) => freeApplicative.pure(k(x))) };
  var freeBind = {
    bind: (v) => (k) => $Free(v._1, link(v._2)($CatList("CatCons", k, $CatQueue(Nil, Nil)))),
    Apply0: () => freeApply
  };
  var freeApply = {
    apply: (f) => (a) => $Free(
      f._1,
      link(f._2)($CatList(
        "CatCons",
        (f$p) => $Free(
          a._1,
          link(a._2)($CatList("CatCons", (a$p) => freeApplicative.pure(f$p(a$p)), $CatQueue(Nil, Nil)))
        ),
        $CatQueue(Nil, Nil)
      ))
    ),
    Functor0: () => freeFunctor
  };
  var freeApplicative = { pure: (x) => $Free($FreeView("Return", x), CatNil), Apply0: () => freeApply };

  // output-es/Data.Array.ST/foreign.js
  var sortByImpl = function() {
    function mergeFromTo(compare, fromOrdering, xs1, xs2, from, to) {
      var mid;
      var i;
      var j;
      var k;
      var x;
      var y;
      var c;
      mid = from + (to - from >> 1);
      if (mid - from > 1)
        mergeFromTo(compare, fromOrdering, xs2, xs1, from, mid);
      if (to - mid > 1)
        mergeFromTo(compare, fromOrdering, xs2, xs1, mid, to);
      i = from;
      j = mid;
      k = from;
      while (i < mid && j < to) {
        x = xs2[i];
        y = xs2[j];
        c = fromOrdering(compare(x)(y));
        if (c > 0) {
          xs1[k++] = y;
          ++j;
        } else {
          xs1[k++] = x;
          ++i;
        }
      }
      while (i < mid) {
        xs1[k++] = xs2[i++];
      }
      while (j < to) {
        xs1[k++] = xs2[j++];
      }
    }
    return function(compare) {
      return function(fromOrdering) {
        return function(xs) {
          return function() {
            if (xs.length < 2)
              return xs;
            mergeFromTo(compare, fromOrdering, xs, xs.slice(0), 0, xs.length);
            return xs;
          };
        };
      };
    };
  }();

  // output-es/Data.Eq/foreign.js
  var refEq = function(r1) {
    return function(r2) {
      return r1 === r2;
    };
  };
  var eqIntImpl = refEq;

  // output-es/Data.Eq/index.js
  var eqInt = { eq: eqIntImpl };

  // output-es/Data.Ord/foreign.js
  var unsafeCompareImpl = function(lt) {
    return function(eq) {
      return function(gt) {
        return function(x) {
          return function(y) {
            return x < y ? lt : x === y ? eq : gt;
          };
        };
      };
    };
  };
  var ordIntImpl = unsafeCompareImpl;

  // output-es/Data.Ord/index.js
  var ordInt = { compare: /* @__PURE__ */ ordIntImpl(LT)(EQ)(GT), Eq0: () => eqInt };

  // output-es/Data.Semigroup/foreign.js
  var concatArray = function(xs) {
    return function(ys) {
      if (xs.length === 0)
        return ys;
      if (ys.length === 0)
        return xs;
      return xs.concat(ys);
    };
  };

  // output-es/Data.Array/foreign.js
  var range = function(start) {
    return function(end) {
      var step = start > end ? -1 : 1;
      var result = new Array(step * (end - start) + 1);
      var i = start, n = 0;
      while (i !== end) {
        result[n++] = i;
        i += step;
      }
      result[n] = i;
      return result;
    };
  };
  var replicateFill = function(count) {
    return function(value) {
      if (count < 1) {
        return [];
      }
      var result = new Array(count);
      return result.fill(value);
    };
  };
  var replicatePolyfill = function(count) {
    return function(value) {
      var result = [];
      var n = 0;
      for (var i = 0; i < count; i++) {
        result[n++] = value;
      }
      return result;
    };
  };
  var replicate = typeof Array.prototype.fill === "function" ? replicateFill : replicatePolyfill;
  var fromFoldableImpl = function() {
    function Cons2(head, tail) {
      this.head = head;
      this.tail = tail;
    }
    var emptyList = {};
    function curryCons(head) {
      return function(tail) {
        return new Cons2(head, tail);
      };
    }
    function listToArray(list) {
      var result = [];
      var count = 0;
      var xs = list;
      while (xs !== emptyList) {
        result[count++] = xs.head;
        xs = xs.tail;
      }
      return result;
    }
    return function(foldr2) {
      return function(xs) {
        return listToArray(foldr2(curryCons)(emptyList)(xs));
      };
    };
  }();
  var sortByImpl2 = function() {
    function mergeFromTo(compare, fromOrdering, xs1, xs2, from, to) {
      var mid;
      var i;
      var j;
      var k;
      var x;
      var y;
      var c;
      mid = from + (to - from >> 1);
      if (mid - from > 1)
        mergeFromTo(compare, fromOrdering, xs2, xs1, from, mid);
      if (to - mid > 1)
        mergeFromTo(compare, fromOrdering, xs2, xs1, mid, to);
      i = from;
      j = mid;
      k = from;
      while (i < mid && j < to) {
        x = xs2[i];
        y = xs2[j];
        c = fromOrdering(compare(x)(y));
        if (c > 0) {
          xs1[k++] = y;
          ++j;
        } else {
          xs1[k++] = x;
          ++i;
        }
      }
      while (i < mid) {
        xs1[k++] = xs2[i++];
      }
      while (j < to) {
        xs1[k++] = xs2[j++];
      }
    }
    return function(compare) {
      return function(fromOrdering) {
        return function(xs) {
          var out;
          if (xs.length < 2)
            return xs;
          out = xs.slice(0);
          mergeFromTo(compare, fromOrdering, out, xs.slice(0), 0, xs.length);
          return out;
        };
      };
    };
  }();

  // output-es/Data.EuclideanRing/foreign.js
  var intDiv = function(x) {
    return function(y) {
      if (y === 0)
        return 0;
      return y > 0 ? Math.floor(x / y) : -Math.floor(x / -y);
    };
  };
  var intMod = function(x) {
    return function(y) {
      if (y === 0)
        return 0;
      var yy = Math.abs(y);
      return (x % yy + yy) % yy;
    };
  };

  // output-es/Partial/foreign.js
  var _crashWith = function(msg) {
    throw new Error(msg);
  };

  // output-es/Effect.Aff/foreign.js
  var Aff = function() {
    var EMPTY = {};
    var PURE = "Pure";
    var THROW = "Throw";
    var CATCH = "Catch";
    var SYNC = "Sync";
    var ASYNC = "Async";
    var BIND = "Bind";
    var BRACKET = "Bracket";
    var FORK = "Fork";
    var SEQ = "Sequential";
    var MAP = "Map";
    var APPLY = "Apply";
    var ALT = "Alt";
    var CONS = "Cons";
    var RESUME = "Resume";
    var RELEASE = "Release";
    var FINALIZER = "Finalizer";
    var FINALIZED = "Finalized";
    var FORKED = "Forked";
    var FIBER = "Fiber";
    var THUNK = "Thunk";
    function Aff2(tag, _1, _2, _3) {
      this.tag = tag;
      this._1 = _1;
      this._2 = _2;
      this._3 = _3;
    }
    function AffCtr(tag) {
      var fn = function(_1, _2, _3) {
        return new Aff2(tag, _1, _2, _3);
      };
      fn.tag = tag;
      return fn;
    }
    function nonCanceler(error2) {
      return new Aff2(PURE, void 0);
    }
    function runEff(eff) {
      try {
        eff();
      } catch (error2) {
        setTimeout(function() {
          throw error2;
        }, 0);
      }
    }
    function runSync(left, right, eff) {
      try {
        return right(eff());
      } catch (error2) {
        return left(error2);
      }
    }
    function runAsync(left, eff, k) {
      try {
        return eff(k)();
      } catch (error2) {
        k(left(error2))();
        return nonCanceler;
      }
    }
    var Scheduler = function() {
      var limit = 1024;
      var size = 0;
      var ix = 0;
      var queue = new Array(limit);
      var draining = false;
      function drain() {
        var thunk;
        draining = true;
        while (size !== 0) {
          size--;
          thunk = queue[ix];
          queue[ix] = void 0;
          ix = (ix + 1) % limit;
          thunk();
        }
        draining = false;
      }
      return {
        isDraining: function() {
          return draining;
        },
        enqueue: function(cb) {
          var i, tmp;
          if (size === limit) {
            tmp = draining;
            drain();
            draining = tmp;
          }
          queue[(ix + size) % limit] = cb;
          size++;
          if (!draining) {
            drain();
          }
        }
      };
    }();
    function Supervisor(util) {
      var fibers = {};
      var fiberId = 0;
      var count = 0;
      return {
        register: function(fiber) {
          var fid = fiberId++;
          fiber.onComplete({
            rethrow: true,
            handler: function(result) {
              return function() {
                count--;
                delete fibers[fid];
              };
            }
          })();
          fibers[fid] = fiber;
          count++;
        },
        isEmpty: function() {
          return count === 0;
        },
        killAll: function(killError, cb) {
          return function() {
            if (count === 0) {
              return cb();
            }
            var killCount = 0;
            var kills = {};
            function kill(fid) {
              kills[fid] = fibers[fid].kill(killError, function(result) {
                return function() {
                  delete kills[fid];
                  killCount--;
                  if (util.isLeft(result) && util.fromLeft(result)) {
                    setTimeout(function() {
                      throw util.fromLeft(result);
                    }, 0);
                  }
                  if (killCount === 0) {
                    cb();
                  }
                };
              })();
            }
            for (var k in fibers) {
              if (fibers.hasOwnProperty(k)) {
                killCount++;
                kill(k);
              }
            }
            fibers = {};
            fiberId = 0;
            count = 0;
            return function(error2) {
              return new Aff2(SYNC, function() {
                for (var k2 in kills) {
                  if (kills.hasOwnProperty(k2)) {
                    kills[k2]();
                  }
                }
              });
            };
          };
        }
      };
    }
    var SUSPENDED = 0;
    var CONTINUE = 1;
    var STEP_BIND = 2;
    var STEP_RESULT = 3;
    var PENDING = 4;
    var RETURN = 5;
    var COMPLETED = 6;
    function Fiber(util, supervisor, aff) {
      var runTick = 0;
      var status = SUSPENDED;
      var step = aff;
      var fail2 = null;
      var interrupt = null;
      var bhead = null;
      var btail = null;
      var attempts = null;
      var bracketCount = 0;
      var joinId = 0;
      var joins = null;
      var rethrow = true;
      function run2(localRunTick) {
        var tmp, result, attempt;
        while (true) {
          tmp = null;
          result = null;
          attempt = null;
          switch (status) {
            case STEP_BIND:
              status = CONTINUE;
              try {
                step = bhead(step);
                if (btail === null) {
                  bhead = null;
                } else {
                  bhead = btail._1;
                  btail = btail._2;
                }
              } catch (e) {
                status = RETURN;
                fail2 = util.left(e);
                step = null;
              }
              break;
            case STEP_RESULT:
              if (util.isLeft(step)) {
                status = RETURN;
                fail2 = step;
                step = null;
              } else if (bhead === null) {
                status = RETURN;
              } else {
                status = STEP_BIND;
                step = util.fromRight(step);
              }
              break;
            case CONTINUE:
              switch (step.tag) {
                case BIND:
                  if (bhead) {
                    btail = new Aff2(CONS, bhead, btail);
                  }
                  bhead = step._2;
                  status = CONTINUE;
                  step = step._1;
                  break;
                case PURE:
                  if (bhead === null) {
                    status = RETURN;
                    step = util.right(step._1);
                  } else {
                    status = STEP_BIND;
                    step = step._1;
                  }
                  break;
                case SYNC:
                  status = STEP_RESULT;
                  step = runSync(util.left, util.right, step._1);
                  break;
                case ASYNC:
                  status = PENDING;
                  step = runAsync(util.left, step._1, function(result2) {
                    return function() {
                      if (runTick !== localRunTick) {
                        return;
                      }
                      runTick++;
                      Scheduler.enqueue(function() {
                        if (runTick !== localRunTick + 1) {
                          return;
                        }
                        status = STEP_RESULT;
                        step = result2;
                        run2(runTick);
                      });
                    };
                  });
                  return;
                case THROW:
                  status = RETURN;
                  fail2 = util.left(step._1);
                  step = null;
                  break;
                case CATCH:
                  if (bhead === null) {
                    attempts = new Aff2(CONS, step, attempts, interrupt);
                  } else {
                    attempts = new Aff2(CONS, step, new Aff2(CONS, new Aff2(RESUME, bhead, btail), attempts, interrupt), interrupt);
                  }
                  bhead = null;
                  btail = null;
                  status = CONTINUE;
                  step = step._1;
                  break;
                case BRACKET:
                  bracketCount++;
                  if (bhead === null) {
                    attempts = new Aff2(CONS, step, attempts, interrupt);
                  } else {
                    attempts = new Aff2(CONS, step, new Aff2(CONS, new Aff2(RESUME, bhead, btail), attempts, interrupt), interrupt);
                  }
                  bhead = null;
                  btail = null;
                  status = CONTINUE;
                  step = step._1;
                  break;
                case FORK:
                  status = STEP_RESULT;
                  tmp = Fiber(util, supervisor, step._2);
                  if (supervisor) {
                    supervisor.register(tmp);
                  }
                  if (step._1) {
                    tmp.run();
                  }
                  step = util.right(tmp);
                  break;
                case SEQ:
                  status = CONTINUE;
                  step = sequential(util, supervisor, step._1);
                  break;
              }
              break;
            case RETURN:
              bhead = null;
              btail = null;
              if (attempts === null) {
                status = COMPLETED;
                step = interrupt || fail2 || step;
              } else {
                tmp = attempts._3;
                attempt = attempts._1;
                attempts = attempts._2;
                switch (attempt.tag) {
                  case CATCH:
                    if (interrupt && interrupt !== tmp && bracketCount === 0) {
                      status = RETURN;
                    } else if (fail2) {
                      status = CONTINUE;
                      step = attempt._2(util.fromLeft(fail2));
                      fail2 = null;
                    }
                    break;
                  case RESUME:
                    if (interrupt && interrupt !== tmp && bracketCount === 0 || fail2) {
                      status = RETURN;
                    } else {
                      bhead = attempt._1;
                      btail = attempt._2;
                      status = STEP_BIND;
                      step = util.fromRight(step);
                    }
                    break;
                  case BRACKET:
                    bracketCount--;
                    if (fail2 === null) {
                      result = util.fromRight(step);
                      attempts = new Aff2(CONS, new Aff2(RELEASE, attempt._2, result), attempts, tmp);
                      if (interrupt === tmp || bracketCount > 0) {
                        status = CONTINUE;
                        step = attempt._3(result);
                      }
                    }
                    break;
                  case RELEASE:
                    attempts = new Aff2(CONS, new Aff2(FINALIZED, step, fail2), attempts, interrupt);
                    status = CONTINUE;
                    if (interrupt && interrupt !== tmp && bracketCount === 0) {
                      step = attempt._1.killed(util.fromLeft(interrupt))(attempt._2);
                    } else if (fail2) {
                      step = attempt._1.failed(util.fromLeft(fail2))(attempt._2);
                    } else {
                      step = attempt._1.completed(util.fromRight(step))(attempt._2);
                    }
                    fail2 = null;
                    bracketCount++;
                    break;
                  case FINALIZER:
                    bracketCount++;
                    attempts = new Aff2(CONS, new Aff2(FINALIZED, step, fail2), attempts, interrupt);
                    status = CONTINUE;
                    step = attempt._1;
                    break;
                  case FINALIZED:
                    bracketCount--;
                    status = RETURN;
                    step = attempt._1;
                    fail2 = attempt._2;
                    break;
                }
              }
              break;
            case COMPLETED:
              for (var k in joins) {
                if (joins.hasOwnProperty(k)) {
                  rethrow = rethrow && joins[k].rethrow;
                  runEff(joins[k].handler(step));
                }
              }
              joins = null;
              if (interrupt && fail2) {
                setTimeout(function() {
                  throw util.fromLeft(fail2);
                }, 0);
              } else if (util.isLeft(step) && rethrow) {
                setTimeout(function() {
                  if (rethrow) {
                    throw util.fromLeft(step);
                  }
                }, 0);
              }
              return;
            case SUSPENDED:
              status = CONTINUE;
              break;
            case PENDING:
              return;
          }
        }
      }
      function onComplete(join2) {
        return function() {
          if (status === COMPLETED) {
            rethrow = rethrow && join2.rethrow;
            join2.handler(step)();
            return function() {
            };
          }
          var jid = joinId++;
          joins = joins || {};
          joins[jid] = join2;
          return function() {
            if (joins !== null) {
              delete joins[jid];
            }
          };
        };
      }
      function kill(error2, cb) {
        return function() {
          if (status === COMPLETED) {
            cb(util.right(void 0))();
            return function() {
            };
          }
          var canceler = onComplete({
            rethrow: false,
            handler: function() {
              return cb(util.right(void 0));
            }
          })();
          switch (status) {
            case SUSPENDED:
              interrupt = util.left(error2);
              status = COMPLETED;
              step = interrupt;
              run2(runTick);
              break;
            case PENDING:
              if (interrupt === null) {
                interrupt = util.left(error2);
              }
              if (bracketCount === 0) {
                if (status === PENDING) {
                  attempts = new Aff2(CONS, new Aff2(FINALIZER, step(error2)), attempts, interrupt);
                }
                status = RETURN;
                step = null;
                fail2 = null;
                run2(++runTick);
              }
              break;
            default:
              if (interrupt === null) {
                interrupt = util.left(error2);
              }
              if (bracketCount === 0) {
                status = RETURN;
                step = null;
                fail2 = null;
              }
          }
          return canceler;
        };
      }
      function join(cb) {
        return function() {
          var canceler = onComplete({
            rethrow: false,
            handler: cb
          })();
          if (status === SUSPENDED) {
            run2(runTick);
          }
          return canceler;
        };
      }
      return {
        kill,
        join,
        onComplete,
        isSuspended: function() {
          return status === SUSPENDED;
        },
        run: function() {
          if (status === SUSPENDED) {
            if (!Scheduler.isDraining()) {
              Scheduler.enqueue(function() {
                run2(runTick);
              });
            } else {
              run2(runTick);
            }
          }
        }
      };
    }
    function runPar(util, supervisor, par, cb) {
      var fiberId = 0;
      var fibers = {};
      var killId = 0;
      var kills = {};
      var early = new Error("[ParAff] Early exit");
      var interrupt = null;
      var root = EMPTY;
      function kill(error2, par2, cb2) {
        var step = par2;
        var head = null;
        var tail = null;
        var count = 0;
        var kills2 = {};
        var tmp, kid;
        loop:
          while (true) {
            tmp = null;
            switch (step.tag) {
              case FORKED:
                if (step._3 === EMPTY) {
                  tmp = fibers[step._1];
                  kills2[count++] = tmp.kill(error2, function(result) {
                    return function() {
                      count--;
                      if (count === 0) {
                        cb2(result)();
                      }
                    };
                  });
                }
                if (head === null) {
                  break loop;
                }
                step = head._2;
                if (tail === null) {
                  head = null;
                } else {
                  head = tail._1;
                  tail = tail._2;
                }
                break;
              case MAP:
                step = step._2;
                break;
              case APPLY:
              case ALT:
                if (head) {
                  tail = new Aff2(CONS, head, tail);
                }
                head = step;
                step = step._1;
                break;
            }
          }
        if (count === 0) {
          cb2(util.right(void 0))();
        } else {
          kid = 0;
          tmp = count;
          for (; kid < tmp; kid++) {
            kills2[kid] = kills2[kid]();
          }
        }
        return kills2;
      }
      function join(result, head, tail) {
        var fail2, step, lhs, rhs, tmp, kid;
        if (util.isLeft(result)) {
          fail2 = result;
          step = null;
        } else {
          step = result;
          fail2 = null;
        }
        loop:
          while (true) {
            lhs = null;
            rhs = null;
            tmp = null;
            kid = null;
            if (interrupt !== null) {
              return;
            }
            if (head === null) {
              cb(fail2 || step)();
              return;
            }
            if (head._3 !== EMPTY) {
              return;
            }
            switch (head.tag) {
              case MAP:
                if (fail2 === null) {
                  head._3 = util.right(head._1(util.fromRight(step)));
                  step = head._3;
                } else {
                  head._3 = fail2;
                }
                break;
              case APPLY:
                lhs = head._1._3;
                rhs = head._2._3;
                if (fail2) {
                  head._3 = fail2;
                  tmp = true;
                  kid = killId++;
                  kills[kid] = kill(early, fail2 === lhs ? head._2 : head._1, function() {
                    return function() {
                      delete kills[kid];
                      if (tmp) {
                        tmp = false;
                      } else if (tail === null) {
                        join(fail2, null, null);
                      } else {
                        join(fail2, tail._1, tail._2);
                      }
                    };
                  });
                  if (tmp) {
                    tmp = false;
                    return;
                  }
                } else if (lhs === EMPTY || rhs === EMPTY) {
                  return;
                } else {
                  step = util.right(util.fromRight(lhs)(util.fromRight(rhs)));
                  head._3 = step;
                }
                break;
              case ALT:
                lhs = head._1._3;
                rhs = head._2._3;
                if (lhs === EMPTY && util.isLeft(rhs) || rhs === EMPTY && util.isLeft(lhs)) {
                  return;
                }
                if (lhs !== EMPTY && util.isLeft(lhs) && rhs !== EMPTY && util.isLeft(rhs)) {
                  fail2 = step === lhs ? rhs : lhs;
                  step = null;
                  head._3 = fail2;
                } else {
                  head._3 = step;
                  tmp = true;
                  kid = killId++;
                  kills[kid] = kill(early, step === lhs ? head._2 : head._1, function() {
                    return function() {
                      delete kills[kid];
                      if (tmp) {
                        tmp = false;
                      } else if (tail === null) {
                        join(step, null, null);
                      } else {
                        join(step, tail._1, tail._2);
                      }
                    };
                  });
                  if (tmp) {
                    tmp = false;
                    return;
                  }
                }
                break;
            }
            if (tail === null) {
              head = null;
            } else {
              head = tail._1;
              tail = tail._2;
            }
          }
      }
      function resolve(fiber) {
        return function(result) {
          return function() {
            delete fibers[fiber._1];
            fiber._3 = result;
            join(result, fiber._2._1, fiber._2._2);
          };
        };
      }
      function run2() {
        var status = CONTINUE;
        var step = par;
        var head = null;
        var tail = null;
        var tmp, fid;
        loop:
          while (true) {
            tmp = null;
            fid = null;
            switch (status) {
              case CONTINUE:
                switch (step.tag) {
                  case MAP:
                    if (head) {
                      tail = new Aff2(CONS, head, tail);
                    }
                    head = new Aff2(MAP, step._1, EMPTY, EMPTY);
                    step = step._2;
                    break;
                  case APPLY:
                    if (head) {
                      tail = new Aff2(CONS, head, tail);
                    }
                    head = new Aff2(APPLY, EMPTY, step._2, EMPTY);
                    step = step._1;
                    break;
                  case ALT:
                    if (head) {
                      tail = new Aff2(CONS, head, tail);
                    }
                    head = new Aff2(ALT, EMPTY, step._2, EMPTY);
                    step = step._1;
                    break;
                  default:
                    fid = fiberId++;
                    status = RETURN;
                    tmp = step;
                    step = new Aff2(FORKED, fid, new Aff2(CONS, head, tail), EMPTY);
                    tmp = Fiber(util, supervisor, tmp);
                    tmp.onComplete({
                      rethrow: false,
                      handler: resolve(step)
                    })();
                    fibers[fid] = tmp;
                    if (supervisor) {
                      supervisor.register(tmp);
                    }
                }
                break;
              case RETURN:
                if (head === null) {
                  break loop;
                }
                if (head._1 === EMPTY) {
                  head._1 = step;
                  status = CONTINUE;
                  step = head._2;
                  head._2 = EMPTY;
                } else {
                  head._2 = step;
                  step = head;
                  if (tail === null) {
                    head = null;
                  } else {
                    head = tail._1;
                    tail = tail._2;
                  }
                }
            }
          }
        root = step;
        for (fid = 0; fid < fiberId; fid++) {
          fibers[fid].run();
        }
      }
      function cancel(error2, cb2) {
        interrupt = util.left(error2);
        var innerKills;
        for (var kid in kills) {
          if (kills.hasOwnProperty(kid)) {
            innerKills = kills[kid];
            for (kid in innerKills) {
              if (innerKills.hasOwnProperty(kid)) {
                innerKills[kid]();
              }
            }
          }
        }
        kills = null;
        var newKills = kill(error2, root, cb2);
        return function(killError) {
          return new Aff2(ASYNC, function(killCb) {
            return function() {
              for (var kid2 in newKills) {
                if (newKills.hasOwnProperty(kid2)) {
                  newKills[kid2]();
                }
              }
              return nonCanceler;
            };
          });
        };
      }
      run2();
      return function(killError) {
        return new Aff2(ASYNC, function(killCb) {
          return function() {
            return cancel(killError, killCb);
          };
        });
      };
    }
    function sequential(util, supervisor, par) {
      return new Aff2(ASYNC, function(cb) {
        return function() {
          return runPar(util, supervisor, par, cb);
        };
      });
    }
    Aff2.EMPTY = EMPTY;
    Aff2.Pure = AffCtr(PURE);
    Aff2.Throw = AffCtr(THROW);
    Aff2.Catch = AffCtr(CATCH);
    Aff2.Sync = AffCtr(SYNC);
    Aff2.Async = AffCtr(ASYNC);
    Aff2.Bind = AffCtr(BIND);
    Aff2.Bracket = AffCtr(BRACKET);
    Aff2.Fork = AffCtr(FORK);
    Aff2.Seq = AffCtr(SEQ);
    Aff2.ParMap = AffCtr(MAP);
    Aff2.ParApply = AffCtr(APPLY);
    Aff2.ParAlt = AffCtr(ALT);
    Aff2.Fiber = Fiber;
    Aff2.Supervisor = Supervisor;
    Aff2.Scheduler = Scheduler;
    Aff2.nonCanceler = nonCanceler;
    return Aff2;
  }();
  var _pure = Aff.Pure;
  var _throwError = Aff.Throw;
  function _map(f) {
    return function(aff) {
      if (aff.tag === Aff.Pure.tag) {
        return Aff.Pure(f(aff._1));
      } else {
        return Aff.Bind(aff, function(value) {
          return Aff.Pure(f(value));
        });
      }
    };
  }
  function _bind(aff) {
    return function(k) {
      return Aff.Bind(aff, k);
    };
  }
  var _liftEffect = Aff.Sync;
  var makeAff = Aff.Async;
  function _makeFiber(util, aff) {
    return function() {
      return Aff.Fiber(util, null, aff);
    };
  }
  var _delay = function() {
    function setDelay(n, k) {
      if (n === 0 && typeof setImmediate !== "undefined") {
        return setImmediate(k);
      } else {
        return setTimeout(k, n);
      }
    }
    function clearDelay(n, t) {
      if (n === 0 && typeof clearImmediate !== "undefined") {
        return clearImmediate(t);
      } else {
        return clearTimeout(t);
      }
    }
    return function(right, ms) {
      return Aff.Async(function(cb) {
        return function() {
          var timer = setDelay(ms, cb(right()));
          return function() {
            return Aff.Sync(function() {
              return right(clearDelay(ms, timer));
            });
          };
        };
      });
    };
  }();
  var _sequential = Aff.Seq;

  // output-es/Effect.Aff/index.js
  var functorAff = { map: _map };
  var ffiUtil = {
    isLeft: (v) => {
      if (v.tag === "Left") {
        return true;
      }
      if (v.tag === "Right") {
        return false;
      }
      fail();
    },
    fromLeft: (v) => {
      if (v.tag === "Left") {
        return v._1;
      }
      if (v.tag === "Right") {
        return _crashWith("unsafeFromLeft: Right");
      }
      fail();
    },
    fromRight: (v) => {
      if (v.tag === "Right") {
        return v._1;
      }
      if (v.tag === "Left") {
        return _crashWith("unsafeFromRight: Left");
      }
      fail();
    },
    left: Left,
    right: Right
  };
  var monadAff = { Applicative0: () => applicativeAff, Bind1: () => bindAff };
  var bindAff = { bind: _bind, Apply0: () => applyAff };
  var applyAff = { apply: (f) => (a) => _bind(f)((f$p) => _bind(a)((a$p) => applicativeAff.pure(f$p(a$p)))), Functor0: () => functorAff };
  var applicativeAff = { pure: _pure, Apply0: () => applyAff };
  var monadEffectAff = { liftEffect: _liftEffect, Monad0: () => monadAff };
  var monadRecAff = {
    tailRecM: (k) => {
      const go = (a) => _bind(k(a))((res) => {
        if (res.tag === "Done") {
          return _pure(res._1);
        }
        if (res.tag === "Loop") {
          return go(res._1);
        }
        fail();
      });
      return go;
    },
    Monad0: () => monadAff
  };

  // output-es/Effect.Aff.Class/index.js
  var monadAffAff = { liftAff: (x) => x, MonadEffect0: () => monadEffectAff };

  // output-es/Data.Map.Internal/index.js
  var $KickUp = (_1, _2, _3, _4) => ({ tag: "KickUp", _1, _2, _3, _4 });
  var $$$Map = (tag, _1, _2, _3, _4, _5, _6, _7) => ({ tag, _1, _2, _3, _4, _5, _6, _7 });
  var $TreeContext = (tag, _1, _2, _3, _4, _5, _6) => ({ tag, _1, _2, _3, _4, _5, _6 });
  var Leaf2 = /* @__PURE__ */ $$$Map("Leaf");
  var lookup = (dictOrd) => (k) => {
    const go = (go$a0$copy) => {
      let go$a0 = go$a0$copy, go$c = true, go$r;
      while (go$c) {
        const v = go$a0;
        if (v.tag === "Leaf") {
          go$c = false;
          go$r = Nothing;
          continue;
        }
        if (v.tag === "Two") {
          const v2 = dictOrd.compare(k)(v._2);
          if (v2.tag === "EQ") {
            go$c = false;
            go$r = $Maybe("Just", v._3);
            continue;
          }
          if (v2.tag === "LT") {
            go$a0 = v._1;
            continue;
          }
          go$a0 = v._4;
          continue;
        }
        if (v.tag === "Three") {
          const v3 = dictOrd.compare(k)(v._2);
          if (v3.tag === "EQ") {
            go$c = false;
            go$r = $Maybe("Just", v._3);
            continue;
          }
          const v4 = dictOrd.compare(k)(v._5);
          if (v4.tag === "EQ") {
            go$c = false;
            go$r = $Maybe("Just", v._6);
            continue;
          }
          if (v3.tag === "LT") {
            go$a0 = v._1;
            continue;
          }
          if (v4.tag === "GT") {
            go$a0 = v._7;
            continue;
          }
          go$a0 = v._4;
          continue;
        }
        fail();
      }
      return go$r;
    };
    return go;
  };
  var fromZipper = (fromZipper$a0$copy) => (fromZipper$a1$copy) => (fromZipper$a2$copy) => {
    let fromZipper$a0 = fromZipper$a0$copy, fromZipper$a1 = fromZipper$a1$copy, fromZipper$a2 = fromZipper$a2$copy, fromZipper$c = true, fromZipper$r;
    while (fromZipper$c) {
      const dictOrd = fromZipper$a0, v = fromZipper$a1, v1 = fromZipper$a2;
      if (v.tag === "Nil") {
        fromZipper$c = false;
        fromZipper$r = v1;
        continue;
      }
      if (v.tag === "Cons") {
        if (v._1.tag === "TwoLeft") {
          fromZipper$a0 = dictOrd;
          fromZipper$a1 = v._2;
          fromZipper$a2 = $$$Map("Two", v1, v._1._1, v._1._2, v._1._3);
          continue;
        }
        if (v._1.tag === "TwoRight") {
          fromZipper$a0 = dictOrd;
          fromZipper$a1 = v._2;
          fromZipper$a2 = $$$Map("Two", v._1._1, v._1._2, v._1._3, v1);
          continue;
        }
        if (v._1.tag === "ThreeLeft") {
          fromZipper$a0 = dictOrd;
          fromZipper$a1 = v._2;
          fromZipper$a2 = $$$Map("Three", v1, v._1._1, v._1._2, v._1._3, v._1._4, v._1._5, v._1._6);
          continue;
        }
        if (v._1.tag === "ThreeMiddle") {
          fromZipper$a0 = dictOrd;
          fromZipper$a1 = v._2;
          fromZipper$a2 = $$$Map("Three", v._1._1, v._1._2, v._1._3, v1, v._1._4, v._1._5, v._1._6);
          continue;
        }
        if (v._1.tag === "ThreeRight") {
          fromZipper$a0 = dictOrd;
          fromZipper$a1 = v._2;
          fromZipper$a2 = $$$Map("Three", v._1._1, v._1._2, v._1._3, v._1._4, v._1._5, v._1._6, v1);
          continue;
        }
        fail();
      }
      fail();
    }
    return fromZipper$r;
  };
  var insert = (dictOrd) => (k) => (v) => {
    const up = (up$a0$copy) => (up$a1$copy) => {
      let up$a0 = up$a0$copy, up$a1 = up$a1$copy, up$c = true, up$r;
      while (up$c) {
        const v1 = up$a0, v2 = up$a1;
        if (v1.tag === "Nil") {
          up$c = false;
          up$r = $$$Map("Two", v2._1, v2._2, v2._3, v2._4);
          continue;
        }
        if (v1.tag === "Cons") {
          if (v1._1.tag === "TwoLeft") {
            up$c = false;
            up$r = fromZipper(dictOrd)(v1._2)($$$Map("Three", v2._1, v2._2, v2._3, v2._4, v1._1._1, v1._1._2, v1._1._3));
            continue;
          }
          if (v1._1.tag === "TwoRight") {
            up$c = false;
            up$r = fromZipper(dictOrd)(v1._2)($$$Map("Three", v1._1._1, v1._1._2, v1._1._3, v2._1, v2._2, v2._3, v2._4));
            continue;
          }
          if (v1._1.tag === "ThreeLeft") {
            up$a0 = v1._2;
            up$a1 = $KickUp($$$Map("Two", v2._1, v2._2, v2._3, v2._4), v1._1._1, v1._1._2, $$$Map("Two", v1._1._3, v1._1._4, v1._1._5, v1._1._6));
            continue;
          }
          if (v1._1.tag === "ThreeMiddle") {
            up$a0 = v1._2;
            up$a1 = $KickUp($$$Map("Two", v1._1._1, v1._1._2, v1._1._3, v2._1), v2._2, v2._3, $$$Map("Two", v2._4, v1._1._4, v1._1._5, v1._1._6));
            continue;
          }
          if (v1._1.tag === "ThreeRight") {
            up$a0 = v1._2;
            up$a1 = $KickUp($$$Map("Two", v1._1._1, v1._1._2, v1._1._3, v1._1._4), v1._1._5, v1._1._6, $$$Map("Two", v2._1, v2._2, v2._3, v2._4));
            continue;
          }
          fail();
        }
        fail();
      }
      return up$r;
    };
    const down = (down$a0$copy) => (down$a1$copy) => {
      let down$a0 = down$a0$copy, down$a1 = down$a1$copy, down$c = true, down$r;
      while (down$c) {
        const v1 = down$a0, v2 = down$a1;
        if (v2.tag === "Leaf") {
          down$c = false;
          down$r = up(v1)($KickUp(Leaf2, k, v, Leaf2));
          continue;
        }
        if (v2.tag === "Two") {
          const v3 = dictOrd.compare(k)(v2._2);
          if (v3.tag === "EQ") {
            down$c = false;
            down$r = fromZipper(dictOrd)(v1)($$$Map("Two", v2._1, k, v, v2._4));
            continue;
          }
          if (v3.tag === "LT") {
            down$a0 = $List("Cons", $TreeContext("TwoLeft", v2._2, v2._3, v2._4), v1);
            down$a1 = v2._1;
            continue;
          }
          down$a0 = $List("Cons", $TreeContext("TwoRight", v2._1, v2._2, v2._3), v1);
          down$a1 = v2._4;
          continue;
        }
        if (v2.tag === "Three") {
          const v3 = dictOrd.compare(k)(v2._2);
          if (v3.tag === "EQ") {
            down$c = false;
            down$r = fromZipper(dictOrd)(v1)($$$Map("Three", v2._1, k, v, v2._4, v2._5, v2._6, v2._7));
            continue;
          }
          const v4 = dictOrd.compare(k)(v2._5);
          if (v4.tag === "EQ") {
            down$c = false;
            down$r = fromZipper(dictOrd)(v1)($$$Map("Three", v2._1, v2._2, v2._3, v2._4, k, v, v2._7));
            continue;
          }
          if (v3.tag === "LT") {
            down$a0 = $List("Cons", $TreeContext("ThreeLeft", v2._2, v2._3, v2._4, v2._5, v2._6, v2._7), v1);
            down$a1 = v2._1;
            continue;
          }
          if (v3.tag === "GT") {
            if (v4.tag === "LT") {
              down$a0 = $List("Cons", $TreeContext("ThreeMiddle", v2._1, v2._2, v2._3, v2._5, v2._6, v2._7), v1);
              down$a1 = v2._4;
              continue;
            }
            down$a0 = $List("Cons", $TreeContext("ThreeRight", v2._1, v2._2, v2._3, v2._4, v2._5, v2._6), v1);
            down$a1 = v2._7;
            continue;
          }
          down$a0 = $List("Cons", $TreeContext("ThreeRight", v2._1, v2._2, v2._3, v2._4, v2._5, v2._6), v1);
          down$a1 = v2._7;
          continue;
        }
        fail();
      }
      return down$r;
    };
    return down(Nil);
  };

  // output-es/Data.Nullable/foreign.js
  function nullable(a, r, f) {
    return a == null ? r : f(a);
  }

  // output-es/Pha.App.Internal/foreign.js
  var TEXT_NODE = 3;
  var compose = (f, g) => f && g ? (x) => f(g(x)) : f || g;
  var patchProperty = (node, key2, newValue) => {
    node[key2] = newValue;
  };
  var patchAttribute = (node, key2, newValue) => {
    if (newValue == null || key2 === "class" && !newValue) {
      node.removeAttribute(key2);
    } else {
      node.setAttribute(key2, newValue);
    }
  };
  var patchEvent = (node, key2, oldValue, newValue, listener, mapf) => {
    if (!node.actions)
      node.actions = {};
    node.actions[key2] = mapf && newValue ? mapf(newValue) : newValue;
    if (!newValue) {
      node.removeEventListener(key2, listener);
    } else if (!oldValue) {
      node.addEventListener(key2, listener);
    }
  };
  var createNode = (vnode, listener, isSvg, mapf) => {
    const node = vnode.type === TEXT_NODE ? document.createTextNode(vnode.tag) : (isSvg = isSvg || vnode.tag === "svg") ? document.createElementNS("http://www.w3.org/2000/svg", vnode.tag) : document.createElement(vnode.tag);
    const props = vnode.props;
    const attrs = vnode.attrs;
    const events = vnode.events;
    const mapf2 = compose(mapf, vnode.mapf);
    for (let k in props) {
      patchProperty(node, k, props[k]);
    }
    for (let k in attrs) {
      patchAttribute(node, k, attrs[k]);
    }
    for (let k in events) {
      patchEvent(node, k, null, events[k], listener, mapf2);
    }
    for (let i = 0, len = vnode.children.length; i < len; i++) {
      node.appendChild(
        createNode(
          getVNode(vnode.children[i]).html,
          listener,
          isSvg,
          mapf2
        )
      );
    }
    vnode.node = node;
    return node;
  };
  var patch = (parent2, node, oldVNode, newVNode, listener, isSvg, mapf) => {
    if (oldVNode === newVNode)
      return;
    if (oldVNode != null && oldVNode.type === TEXT_NODE && newVNode.type === TEXT_NODE) {
      if (oldVNode.tag !== newVNode.tag)
        node.nodeValue = newVNode.tag;
    } else if (oldVNode == null || oldVNode.tag !== newVNode.tag) {
      node = parent2.insertBefore(
        createNode(newVNode, listener, isSvg, mapf),
        node
      );
      if (oldVNode) {
        oldVNode.node.remove();
      }
    } else {
      const oldProps = oldVNode.props;
      const newProps = newVNode.props;
      for (let i in { ...oldProps, ...newProps }) {
        if (oldProps[i] !== newProps[i]) {
          patchProperty(node, i, newProps[i]);
        }
      }
      const oldAttrs = oldVNode.attrs;
      const newAttrs = newVNode.attrs;
      for (let i in { ...oldAttrs, ...newAttrs }) {
        if (oldAttrs[i] !== newAttrs[i]) {
          patchAttribute(node, i, newAttrs[i]);
        }
      }
      const oldEvents = oldVNode.events;
      const newEvents = newVNode.events;
      for (let i in { ...oldEvents, ...newEvents }) {
        if (oldEvents[i] !== newEvents[i]) {
          patchEvent(node, i, oldEvents[i], newEvents[i], listener, mapf);
        }
      }
      const oldVKids = oldVNode.children;
      const newVKids = newVNode.children;
      let oldTail = oldVKids.length - 1;
      let newTail = newVKids.length - 1;
      mapf = compose(mapf, newVNode.mapf);
      isSvg = isSvg || newVNode.tag === "svg";
      if (!newVNode.keyed) {
        for (let i = 0; i <= oldTail && i <= newTail; i++) {
          const oldVNode2 = oldVKids[i].html;
          const newVNode2 = getVNode(newVKids[i], oldVNode2).html;
          patch(node, oldVNode2.node, oldVNode2, newVNode2, listener, isSvg, mapf);
        }
        for (let i = oldTail + 1; i <= newTail; i++) {
          const newVNode2 = getVNode(newVKids[i], oldVNode).html;
          node.appendChild(
            createNode(newVNode2, listener, isSvg, mapf)
          );
        }
        for (let i = newTail + 1; i <= oldTail; i++) {
          oldVKids[i].html.node.remove();
        }
      } else {
        let oldHead = 0;
        let newHead = 0;
        while (newHead <= newTail && oldHead <= oldTail) {
          const { key: oldKey, html: oldVNode2 } = oldVKids[oldHead];
          if (oldKey !== newVKids[newHead].key)
            break;
          const newKNode = getVNode(newVKids[newHead], oldVNode2);
          patch(node, oldVNode2.node, oldVNode2, newKNode.html, listener, isSvg, mapf);
          newHead++;
          oldHead++;
        }
        while (newHead <= newTail && oldHead <= oldTail) {
          const { key: oldKey, html: oldVNode2 } = oldVKids[oldTail];
          if (oldKey !== newVKids[newTail].key)
            break;
          const newKNode = getVNode(newVKids[newTail], oldVNode2);
          patch(node, oldVNode2.node, oldVNode2, newKNode.html, listener, isSvg, mapf);
          newTail--;
          oldTail--;
        }
        if (oldHead > oldTail) {
          while (newHead <= newTail) {
            const newVNode2 = getVNode(newVKids[newHead]).html;
            node.insertBefore(
              createNode(newVNode2, listener, isSvg, mapf),
              oldVKids[oldHead] && oldVKids[oldHead].html.node
            );
            newHead++;
          }
        } else if (newHead > newTail) {
          while (oldHead <= oldTail) {
            oldVKids[oldHead].html.node.remove();
            oldHead++;
          }
        } else {
          const keyed = {};
          const newKeyed = {};
          for (let i = oldHead; i <= oldTail; i++) {
            keyed[oldVKids[i].key] = oldVKids[i].html;
          }
          while (newHead <= newTail) {
            const { key: oldKey, html: oldVKid } = oldVKids[oldHead] || { key: null, html: null };
            const { key: newKey, html: newVKid } = getVNode(newVKids[newHead], oldVKid);
            if (newKeyed[oldKey] || oldVKids[oldHead + 1] && newKey === oldVKids[oldHead + 1].key) {
              oldHead++;
              continue;
            }
            if (oldKey === newKey) {
              patch(node, oldVKid.node, oldVKid, newVKid, listener, isSvg, mapf);
              newKeyed[newKey] = true;
              oldHead++;
            } else {
              const vkid = keyed[newKey];
              if (vkid != null) {
                patch(
                  node,
                  node.insertBefore(vkid.node, oldVKid.node),
                  vkid,
                  newVKids[newHead].html,
                  listener,
                  isSvg,
                  mapf
                );
                newKeyed[newKey] = true;
              } else {
                patch(node, oldVKid && oldVKid.node, null, newVKids[newHead].html, listener, isSvg, mapf);
              }
            }
            newHead++;
          }
          for (let i in keyed) {
            if (!newKeyed[i]) {
              keyed[i].node.remove();
            }
          }
        }
      }
    }
    newVNode.node = node;
    return node;
  };
  var propsChanged = (a, b) => {
    for (let i = 0; i < a.length; i++)
      if (a[i] !== b[i])
        return true;
    return false;
  };
  var getVNode = (newVNode, oldVNode) => {
    if (typeof newVNode.html.type === "function") {
      if (!oldVNode || oldVNode.memo == null || propsChanged(oldVNode.memo, newVNode.html.memo)) {
        oldVNode = copyVNode(newVNode.html.type(...newVNode.html.memo));
        oldVNode.memo = newVNode.html.memo;
      }
      newVNode.html = oldVNode;
    }
    return newVNode;
  };
  var copyVNode = (vnode) => ({
    ...vnode,
    children: vnode.children && vnode.children.map(({ key: key2, html }) => ({ key: key2, html: copyVNode(html) }))
  });
  var getAction = (target, type) => target.actions[type];
  var unsafePatch = patch;
  var unsafeLinkNode = (node) => (vdom) => {
    vdom.node = node;
    return vdom;
  };

  // output-es/Pha.Html.Core/foreign.js
  var _h = (tag, ps, children2, keyed = false) => {
    const style = [];
    const props = {};
    const attrs = {};
    const events = {};
    const vdom = { tag, children: children2, props, attrs, events, node: null, keyed };
    const n = ps.length;
    for (let i = 0; i < n; i++) {
      const [t, k, v] = ps[i];
      if (t === 0)
        props[k] = v;
      else if (t === 1)
        attrs[k] = v;
      else if (t === 2)
        events[k] = v;
      else if (t === 3)
        attrs.class = attrs.class ? attrs.class + " " + k : k;
      else if (t === 4)
        style.push(k + ":" + v);
    }
    const style_ = style.join(";");
    if (style_)
      attrs.style = style_;
    return vdom;
  };
  var elemImpl = (tag, ps, children2) => _h(tag, ps, children2.map((html) => ({ key: null, html })));
  var keyedImpl = (tag, ps, children2) => _h(tag, ps, children2, true);
  var createTextVNode = (text2) => ({
    tag: text2,
    props: {},
    children: [],
    type: 3
  });
  var unsafeOnWithEffectImpl = (k, v) => [2, k, v];
  var class_ = (cls) => [3, cls];
  var styleImpl = (k, v) => [4, k, v];
  var text = createTextVNode;
  var lazyImpl = (view2, val) => ({ memo: [val], type: view2 });

  // output-es/Unsafe.Reference/foreign.js
  function reallyUnsafeRefEq(a) {
    return function(b) {
      return a === b;
    };
  }

  // output-es/Pha.Update.Internal/index.js
  var $UpdateF = (tag, _1, _2) => ({ tag, _1, _2 });
  var identity9 = (x) => x;
  var monadEffectUpdate = (dictMonadEffect) => ({
    liftEffect: (x) => $Free(
      $FreeView(
        "Bind",
        $UpdateF("Lift", dictMonadEffect.liftEffect(x)),
        (x$1) => $Free($FreeView("Return", x$1), CatNil)
      ),
      CatNil
    ),
    Monad0: () => freeMonad
  });
  var monadAffUpdate = (dictMonadAff) => {
    const monadEffectUpdate1 = monadEffectUpdate(dictMonadAff.MonadEffect0());
    return {
      liftAff: (x) => $Free(
        $FreeView(
          "Bind",
          $UpdateF("Lift", dictMonadAff.liftAff(x)),
          (x$1) => $Free($FreeView("Return", x$1), CatNil)
        ),
        CatNil
      ),
      MonadEffect0: () => monadEffectUpdate1
    };
  };
  var functorUpdateF = (dictFunctor) => ({
    map: (v) => (v1) => {
      if (v1.tag === "State") {
        return $UpdateF(
          "State",
          (x) => {
            const $0 = v1._1(x);
            return $Tuple(v($0._1), $0._2);
          }
        );
      }
      if (v1.tag === "Lift") {
        return $UpdateF("Lift", dictFunctor.map(v)(v1._1));
      }
      if (v1.tag === "Subscribe") {
        return $UpdateF("Subscribe", v1._1, (x) => v(v1._2(x)));
      }
      if (v1.tag === "Unsubscribe") {
        return $UpdateF("Unsubscribe", v1._1, v(v1._2));
      }
      fail();
    }
  });

  // output-es/Web.Internal.FFI/foreign.js
  function _unsafeReadProtoTagged(nothing, just, name2, value) {
    if (typeof window !== "undefined") {
      var ty = window[name2];
      if (ty != null && value instanceof ty) {
        return just(value);
      }
    }
    var obj = value;
    while (obj != null) {
      var proto = Object.getPrototypeOf(obj);
      var constructorName = proto.constructor.name;
      if (constructorName === name2) {
        return just(value);
      } else if (constructorName === "Object") {
        return nothing;
      }
      obj = proto;
    }
    return nothing;
  }

  // output-es/Web.DOM.Document/foreign.js
  var getEffProp = function(name2) {
    return function(doc) {
      return function() {
        return doc[name2];
      };
    };
  };
  var url = getEffProp("URL");
  var documentURI = getEffProp("documentURI");
  var origin = getEffProp("origin");
  var compatMode = getEffProp("compatMode");
  var characterSet = getEffProp("characterSet");
  var contentType = getEffProp("contentType");
  var _documentElement = getEffProp("documentElement");
  function createTextNode(data) {
    return function(doc) {
      return function() {
        return doc.createTextNode(data);
      };
    };
  }

  // output-es/Web.DOM.Node/foreign.js
  var getEffProp2 = function(name2) {
    return function(node) {
      return function() {
        return node[name2];
      };
    };
  };
  var baseURI = getEffProp2("baseURI");
  var _ownerDocument = getEffProp2("ownerDocument");
  var _parentNode = getEffProp2("parentNode");
  var _parentElement = getEffProp2("parentElement");
  var childNodes = getEffProp2("childNodes");
  var _firstChild = getEffProp2("firstChild");
  var _lastChild = getEffProp2("lastChild");
  var _previousSibling = getEffProp2("previousSibling");
  var _nextSibling = getEffProp2("nextSibling");
  var _nodeValue = getEffProp2("nodeValue");
  var textContent = getEffProp2("textContent");
  function appendChild(node) {
    return function(parent2) {
      return function() {
        parent2.appendChild(node);
      };
    };
  }

  // output-es/Web.DOM.ParentNode/foreign.js
  var getEffProp3 = function(name2) {
    return function(node) {
      return function() {
        return node[name2];
      };
    };
  };
  var children = getEffProp3("children");
  var _firstElementChild = getEffProp3("firstElementChild");
  var _lastElementChild = getEffProp3("lastElementChild");
  var childElementCount = getEffProp3("childElementCount");
  function _querySelector(selector) {
    return function(node) {
      return function() {
        return node.querySelector(selector);
      };
    };
  }

  // output-es/Web.DOM.ParentNode/index.js
  var querySelector = (qs) => {
    const $0 = _querySelector(qs);
    return (x) => {
      const $1 = $0(x);
      return () => {
        const a$p = $1();
        return nullable(a$p, Nothing, Just);
      };
    };
  };

  // output-es/Web.Event.Event/foreign.js
  function _currentTarget(e) {
    return e.currentTarget;
  }
  function type_(e) {
    return e.type;
  }

  // output-es/Web.HTML/foreign.js
  var windowImpl = function() {
    return window;
  };

  // output-es/Web.HTML.Window/foreign.js
  function document2(window2) {
    return function() {
      return window2.document;
    };
  }

  // output-es/Pha.App/index.js
  var for_2 = /* @__PURE__ */ for_(applicativeEffect)(foldableMaybe);
  var for_1 = /* @__PURE__ */ for_(applicativeAff)(foldableMaybe);
  var runFreeM2 = /* @__PURE__ */ runFreeM(/* @__PURE__ */ functorUpdateF(functorAff))(monadRecAff);
  var dispatchEvent = (iapp) => (ev) => (handler) => {
    const $0 = handler(ev);
    return () => {
      const msg$p = $0();
      return for_2(msg$p)(iapp.update(iapp))();
    };
  };
  var render = (v) => (newVDom) => {
    const $0 = v.node;
    const $1 = v.vdom;
    return () => {
      const oldVDom = $1.value;
      const node1 = $0.value;
      const a$p = _parentNode(node1)();
      return for_2(nullable(a$p, Nothing, Just))((pnode$p) => {
        const vdom2 = copyVNode(newVDom);
        return () => {
          const node2 = unsafePatch(
            pnode$p,
            node1,
            oldVDom,
            vdom2,
            (e) => {
              const $2 = type_(e);
              return for_2(nullable(_currentTarget(e), Nothing, Just))((target) => () => {
                const fn = getAction(target, $2);
                return dispatchEvent(v)(e)(fn)();
              })();
            }
          );
          $0.value = node2;
          return $1.value = vdom2;
        };
      })();
    };
  };
  var setState = (v) => (newState) => {
    const $0 = v.state;
    return () => {
      const oldState = $0.value;
      const $1 = reallyUnsafeRefEq(oldState)(newState);
      if (!$1) {
        $0.value = newState;
        return render(v)(v.view(newState))();
      }
      if ($1) {
        return;
      }
      fail();
    };
  };
  var interpret = (update2) => (v) => (v1) => {
    const $0 = v.subscriptions;
    return runFreeM2((v2) => {
      if (v2.tag === "State") {
        return _bind(_liftEffect((() => {
          const $1 = v.state;
          return () => $1.value;
        })()))((st) => {
          const v3 = v2._1(st);
          const $1 = v3._1;
          return _bind(_liftEffect(setState(v)(v3._2)))(() => _pure($1));
        });
      }
      if (v2.tag === "Lift") {
        return v2._1;
      }
      if (v2.tag === "Subscribe") {
        return _bind(_liftEffect(v2._1((msg) => {
          const $1 = _makeFiber(ffiUtil, interpret(update2)(v)(update2(msg)));
          return () => {
            const fiber = $1();
            fiber.run();
          };
        })))((canceler) => _bind(_liftEffect((() => {
          const $1 = v.freshId;
          return () => {
            const id = $1.value;
            $1.value = id + 1 | 0;
            return id;
          };
        })()))((id) => _bind(_liftEffect((() => {
          const $1 = insert(ordInt)(id)(canceler);
          return () => {
            const $2 = $0.value;
            $0.value = $1($2);
          };
        })()))(() => _pure(v2._2(id)))));
      }
      if (v2.tag === "Unsubscribe") {
        const $1 = v2._2;
        const $2 = v2._1;
        return _bind(_liftEffect(() => $0.value))((subs) => _bind(for_1(lookup(ordInt)($2)(subs))(_liftEffect))(() => _pure($1)));
      }
      fail();
    })(v1);
  };
  var app$p = (v) => {
    const $0 = v.init.model;
    const $1 = v.init.msg;
    const $2 = v.selector;
    const $3 = v.update;
    const $4 = v.view;
    return () => {
      const $5 = windowImpl();
      const parentNode = document2($5)();
      const a$p = querySelector($2)(parentNode)();
      return for_2(a$p.tag === "Just" ? $Maybe("Just", a$p._1) : Nothing)((node_) => () => {
        const state = { value: $0 };
        const $6 = windowImpl();
        const $7 = document2($6)();
        const emptyNode = createTextNode("")($7)();
        appendChild(emptyNode)(node_)();
        const node = { value: emptyNode };
        const vdom = { value: unsafeLinkNode(emptyNode)(text("")) };
        const subscriptions = { value: Leaf2 };
        const freshId = { value: 0 };
        const iapp = { view: $4, update: $3, state, node, vdom, subscriptions, freshId };
        render(iapp)($4($0))();
        return for_2($1)(iapp.update(iapp))();
      })();
    };
  };
  var app = (v) => {
    const $0 = v.update;
    return app$p({
      init: v.init,
      view: v.view,
      selector: v.selector,
      update: (iapp) => (msg) => {
        const $1 = _makeFiber(ffiUtil, interpret($0)(iapp)($0(msg)));
        return () => {
          const fiber = $1();
          fiber.run();
        };
      }
    });
  };

  // output-es/Web.Event.EventTarget/foreign.js
  function eventListener(fn) {
    return function() {
      return function(event) {
        return fn(event)();
      };
    };
  }
  function addEventListener(type) {
    return function(listener) {
      return function(useCapture) {
        return function(target) {
          return function() {
            return target.addEventListener(type, listener, useCapture);
          };
        };
      };
    };
  }
  function removeEventListener(type) {
    return function(listener) {
      return function(useCapture) {
        return function(target) {
          return function() {
            return target.removeEventListener(type, listener, useCapture);
          };
        };
      };
    };
  }

  // output-es/Web.UIEvent.KeyboardEvent/foreign.js
  function key(e) {
    return e.key;
  }

  // output-es/Pha.Subscriptions/index.js
  var eventListener2 = (name2) => (target) => (decoder) => $Free(
    $FreeView(
      "Bind",
      $UpdateF(
        "Subscribe",
        (dispatch) => {
          const $0 = eventListener((ev) => {
            const $02 = decoder(ev);
            return () => {
              const v = $02();
              if (v.tag === "Nothing") {
                return;
              }
              if (v.tag === "Just") {
                return dispatch(v._1)();
              }
              fail();
            };
          });
          return () => {
            const listener = $0();
            addEventListener(name2)(listener)(false)(target)();
            return removeEventListener(name2)(listener)(false)(target);
          };
        },
        identity9
      ),
      (x) => $Free($FreeView("Return", x), CatNil)
    ),
    CatNil
  );
  var onKeyDown = (dictMonadEffect) => {
    const liftEffect = monadEffectUpdate(dictMonadEffect).liftEffect;
    return (f) => {
      const $0 = liftEffect(() => windowImpl());
      return $Free(
        $0._1,
        link($0._2)($CatList(
          "CatCons",
          (target) => eventListener2("keydown")(target)((ev) => {
            const $1 = _unsafeReadProtoTagged(Nothing, Just, "KeyboardEvent", ev);
            if ($1.tag === "Just") {
              const $2 = f(key($1._1));
              return () => $2;
            }
            return () => Nothing;
          }),
          $CatQueue(Nil, Nil)
        ))
      );
    };
  };

  // output-es/Example.Counter2/index.js
  var $Msg = (tag) => ({ tag });
  var onKeyDown2 = /* @__PURE__ */ onKeyDown(monadEffectAff);
  var delay = /* @__PURE__ */ (() => {
    const $0 = monadAffUpdate(monadAffAff).liftAff;
    return (x) => $0(_delay(Right, x));
  })();
  var Init = /* @__PURE__ */ $Msg("Init");
  var Increment = /* @__PURE__ */ $Msg("Increment");
  var DelayedIncrement = /* @__PURE__ */ $Msg("DelayedIncrement");
  var spanCounter = (v) => elemImpl("span", [], [text(showIntImpl(v))]);
  var view = (counter) => elemImpl(
    "div",
    [],
    [
      elemImpl("div", [class_("counter")], [text(showIntImpl(counter))]),
      elemImpl("button", [unsafeOnWithEffectImpl("click", (x) => () => $Maybe("Just", Increment))], [text("Increment")]),
      elemImpl(
        "button",
        [unsafeOnWithEffectImpl("click", (x) => () => $Maybe("Just", DelayedIncrement))],
        [text("Delayed Increment")]
      ),
      elemImpl(
        "div",
        [],
        [
          elemImpl("span", [], [text("green when the counter is even")]),
          elemImpl("div", [class_("box"), styleImpl("background-color", (counter & 1) === 0 ? "blue" : "red")], [])
        ]
      ),
      elemImpl("h3", [], [text("press I to increment the counter")]),
      elemImpl("hr", [], []),
      elemImpl("h3", [], [text("keyed")]),
      keyedImpl(
        "div",
        [],
        concatArray(arrayMap((i) => ({ key: "r" + showIntImpl(i), html: text("r" + showIntImpl(i)) }))(range(0)(intMod(counter)(4))))(concatArray([
          { key: "test", html: text("test") }
        ])(arrayMap((i) => ({ key: "q" + showIntImpl(i), html: text("q" + showIntImpl(i)) }))(range(0)(intMod(counter)(4)))))
      ),
      elemImpl("hr", [], []),
      elemImpl("h3", [], [text("non keyed")]),
      elemImpl(
        "div",
        [],
        concatArray(arrayMap((x) => text(showIntImpl(x)))(range(0)(intMod(counter)(4))))(concatArray([
          text("test")
        ])(arrayMap((x) => text(showIntImpl(x)))(range(0)(intMod(counter)(4)))))
      ),
      elemImpl("hr", [], []),
      elemImpl("h3", [], [text("lazy")]),
      lazyImpl(spanCounter, intDiv(counter)(2)),
      elemImpl("hr", [], []),
      elemImpl("h3", [], [text("duplicate")]),
      elemImpl("div", [], replicate(intMod(counter)(4))(text("t")))
    ]
  );
  var keyDownHandler = (v) => {
    if (v === "i") {
      return $Maybe("Just", Increment);
    }
    return Nothing;
  };
  var update = (v) => {
    if (v.tag === "Init") {
      const $0 = onKeyDown2(keyDownHandler);
      return $Free(
        $0._1,
        link($0._2)($CatList(
          "CatCons",
          (x) => $Free($FreeView("Return", void 0), CatNil),
          $CatQueue(Nil, Nil)
        ))
      );
    }
    if (v.tag === "Increment") {
      return $Free(
        $FreeView(
          "Bind",
          $UpdateF("State", (s) => $Tuple(void 0, s + 1 | 0)),
          (x) => $Free($FreeView("Return", x), CatNil)
        ),
        CatNil
      );
    }
    if (v.tag === "DelayedIncrement") {
      const $0 = delay(1e3);
      return $Free(
        $0._1,
        link($0._2)($CatList(
          "CatCons",
          () => $Free(
            $FreeView(
              "Bind",
              $UpdateF("State", (s) => $Tuple(void 0, s + 1 | 0)),
              (x) => $Free($FreeView("Return", x), CatNil)
            ),
            CatNil
          ),
          $CatQueue(Nil, Nil)
        ))
      );
    }
    fail();
  };
  var main = /* @__PURE__ */ app({ init: { model: 0, msg: /* @__PURE__ */ $Maybe("Just", Init) }, view, update, selector: "#root" });

  // <stdin>
  main();
})();
