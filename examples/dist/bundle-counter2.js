// output/Control.Semigroupoid/index.js
var semigroupoidFn = {
  compose: function(f) {
    return function(g) {
      return function(x) {
        return f(g(x));
      };
    };
  }
};

// output/Control.Category/index.js
var identity = function(dict) {
  return dict.identity;
};
var categoryFn = {
  identity: function(x) {
    return x;
  },
  Semigroupoid0: function() {
    return semigroupoidFn;
  }
};

// output/Data.Function/index.js
var flip = function(f) {
  return function(b) {
    return function(a) {
      return f(a)(b);
    };
  };
};
var $$const = function(a) {
  return function(v) {
    return a;
  };
};

// output/Data.Functor/foreign.js
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

// output/Data.Unit/foreign.js
var unit = void 0;

// output/Data.Functor/index.js
var map = function(dict) {
  return dict.map;
};
var mapFlipped = function(dictFunctor) {
  return function(fa) {
    return function(f) {
      return map(dictFunctor)(f)(fa);
    };
  };
};
var $$void = function(dictFunctor) {
  return map(dictFunctor)($$const(unit));
};
var functorArray = {
  map: arrayMap
};

// output/Control.Apply/index.js
var apply = function(dict) {
  return dict.apply;
};
var applySecond = function(dictApply) {
  return function(a) {
    return function(b) {
      return apply(dictApply)(map(dictApply.Functor0())($$const(identity(categoryFn)))(a))(b);
    };
  };
};

// output/Control.Applicative/index.js
var pure = function(dict) {
  return dict.pure;
};
var unless = function(dictApplicative) {
  return function(v) {
    return function(v1) {
      if (!v) {
        return v1;
      }
      ;
      if (v) {
        return pure(dictApplicative)(unit);
      }
      ;
      throw new Error("Failed pattern match at Control.Applicative (line 68, column 1 - line 68, column 65): " + [v.constructor.name, v1.constructor.name]);
    };
  };
};
var liftA1 = function(dictApplicative) {
  return function(f) {
    return function(a) {
      return apply(dictApplicative.Apply0())(pure(dictApplicative)(f))(a);
    };
  };
};

// output/Control.Bind/index.js
var discard = function(dict) {
  return dict.discard;
};
var bind = function(dict) {
  return dict.bind;
};
var bindFlipped = function(dictBind) {
  return flip(bind(dictBind));
};
var discardUnit = {
  discard: function(dictBind) {
    return bind(dictBind);
  }
};

// output/Data.Bounded/foreign.js
var topChar = String.fromCharCode(65535);
var bottomChar = String.fromCharCode(0);
var topNumber = Number.POSITIVE_INFINITY;
var bottomNumber = Number.NEGATIVE_INFINITY;

// output/Data.Ring/foreign.js
var intSub = function(x) {
  return function(y) {
    return x - y | 0;
  };
};

// output/Data.Semiring/foreign.js
var intAdd = function(x) {
  return function(y) {
    return x + y | 0;
  };
};
var intMul = function(x) {
  return function(y) {
    return x * y | 0;
  };
};

// output/Data.Semiring/index.js
var semiringInt = {
  add: intAdd,
  zero: 0,
  mul: intMul,
  one: 1
};

// output/Data.Ring/index.js
var ringInt = {
  sub: intSub,
  Semiring0: function() {
    return semiringInt;
  }
};

// output/Data.Show/foreign.js
var showIntImpl = function(n) {
  return n.toString();
};

// output/Data.Show/index.js
var showInt = {
  show: showIntImpl
};
var show = function(dict) {
  return dict.show;
};

// output/Data.EuclideanRing/foreign.js
var intDegree = function(x) {
  return Math.min(Math.abs(x), 2147483647);
};
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

// output/Data.CommutativeRing/index.js
var commutativeRingInt = {
  Ring0: function() {
    return ringInt;
  }
};

// output/Data.EuclideanRing/index.js
var mod = function(dict) {
  return dict.mod;
};
var euclideanRingInt = {
  degree: intDegree,
  div: intDiv,
  mod: intMod,
  CommutativeRing0: function() {
    return commutativeRingInt;
  }
};
var div = function(dict) {
  return dict.div;
};

// output/Data.Semigroup/foreign.js
var concatArray = function(xs) {
  return function(ys) {
    if (xs.length === 0)
      return ys;
    if (ys.length === 0)
      return xs;
    return xs.concat(ys);
  };
};

// output/Data.Semigroup/index.js
var semigroupArray = {
  append: concatArray
};
var append = function(dict) {
  return dict.append;
};

// output/Data.Monoid/index.js
var mempty = function(dict) {
  return dict.mempty;
};

// output/Data.Tuple/index.js
var Tuple = /* @__PURE__ */ function() {
  function Tuple2(value0, value1) {
    this.value0 = value0;
    this.value1 = value1;
  }
  ;
  Tuple2.create = function(value0) {
    return function(value1) {
      return new Tuple2(value0, value1);
    };
  };
  return Tuple2;
}();

// output/Control.Monad.State.Class/index.js
var state = function(dict) {
  return dict.state;
};
var modify_ = function(dictMonadState) {
  return function(f) {
    return state(dictMonadState)(function(s) {
      return new Tuple(unit, f(s));
    });
  };
};

// output/Data.Array/foreign.js
var range = function(start2) {
  return function(end) {
    var step2 = start2 > end ? -1 : 1;
    var result = new Array(step2 * (end - start2) + 1);
    var i = start2, n = 0;
    while (i !== end) {
      result[n++] = i;
      i += step2;
    }
    result[n] = i;
    return result;
  };
};
var replicateFill = function(count) {
  return function(value12) {
    if (count < 1) {
      return [];
    }
    var result = new Array(count);
    return result.fill(value12);
  };
};
var replicatePolyfill = function(count) {
  return function(value12) {
    var result = [];
    var n = 0;
    for (var i = 0; i < count; i++) {
      result[n++] = value12;
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
  return function(foldr3) {
    return function(xs) {
      return listToArray(foldr3(curryCons)(emptyList)(xs));
    };
  };
}();
var sortByImpl = function() {
  function mergeFromTo(compare2, fromOrdering, xs1, xs2, from2, to) {
    var mid;
    var i;
    var j;
    var k;
    var x;
    var y;
    var c;
    mid = from2 + (to - from2 >> 1);
    if (mid - from2 > 1)
      mergeFromTo(compare2, fromOrdering, xs2, xs1, from2, mid);
    if (to - mid > 1)
      mergeFromTo(compare2, fromOrdering, xs2, xs1, mid, to);
    i = from2;
    j = mid;
    k = from2;
    while (i < mid && j < to) {
      x = xs2[i];
      y = xs2[j];
      c = fromOrdering(compare2(x)(y));
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
  return function(compare2) {
    return function(fromOrdering) {
      return function(xs) {
        var out;
        if (xs.length < 2)
          return xs;
        out = xs.slice(0);
        mergeFromTo(compare2, fromOrdering, out, xs.slice(0), 0, xs.length);
        return out;
      };
    };
  };
}();

// output/Control.Monad/index.js
var ap = function(dictMonad) {
  return function(f) {
    return function(a) {
      return bind(dictMonad.Bind1())(f)(function(f$prime) {
        return bind(dictMonad.Bind1())(a)(function(a$prime) {
          return pure(dictMonad.Applicative0())(f$prime(a$prime));
        });
      });
    };
  };
};

// output/Data.Maybe/index.js
var Nothing = /* @__PURE__ */ function() {
  function Nothing2() {
  }
  ;
  Nothing2.value = new Nothing2();
  return Nothing2;
}();
var Just = /* @__PURE__ */ function() {
  function Just2(value0) {
    this.value0 = value0;
  }
  ;
  Just2.create = function(value0) {
    return new Just2(value0);
  };
  return Just2;
}();
var functorMaybe = {
  map: function(v) {
    return function(v1) {
      if (v1 instanceof Just) {
        return new Just(v(v1.value0));
      }
      ;
      return Nothing.value;
    };
  }
};
var applyMaybe = {
  apply: function(v) {
    return function(v1) {
      if (v instanceof Just) {
        return map(functorMaybe)(v.value0)(v1);
      }
      ;
      if (v instanceof Nothing) {
        return Nothing.value;
      }
      ;
      throw new Error("Failed pattern match at Data.Maybe (line 67, column 1 - line 69, column 30): " + [v.constructor.name, v1.constructor.name]);
    };
  },
  Functor0: function() {
    return functorMaybe;
  }
};
var bindMaybe = {
  bind: function(v) {
    return function(v1) {
      if (v instanceof Just) {
        return v1(v.value0);
      }
      ;
      if (v instanceof Nothing) {
        return Nothing.value;
      }
      ;
      throw new Error("Failed pattern match at Data.Maybe (line 125, column 1 - line 127, column 28): " + [v.constructor.name, v1.constructor.name]);
    };
  },
  Apply0: function() {
    return applyMaybe;
  }
};

// output/Data.Either/index.js
var Left = /* @__PURE__ */ function() {
  function Left2(value0) {
    this.value0 = value0;
  }
  ;
  Left2.create = function(value0) {
    return new Left2(value0);
  };
  return Left2;
}();
var Right = /* @__PURE__ */ function() {
  function Right2(value0) {
    this.value0 = value0;
  }
  ;
  Right2.create = function(value0) {
    return new Right2(value0);
  };
  return Right2;
}();

// output/Effect/foreign.js
var pureE = function(a) {
  return function() {
    return a;
  };
};
var bindE = function(a) {
  return function(f) {
    return function() {
      return f(a())();
    };
  };
};

// output/Effect/index.js
var $runtime_lazy = function(name15, moduleName, init) {
  var state4 = 0;
  var val;
  return function(lineNumber) {
    if (state4 === 2)
      return val;
    if (state4 === 1)
      throw new ReferenceError(name15 + " was needed before it finished initializing (module " + moduleName + ", line " + lineNumber + ")", moduleName, lineNumber);
    state4 = 1;
    val = init();
    state4 = 2;
    return val;
  };
};
var monadEffect = {
  Applicative0: function() {
    return applicativeEffect;
  },
  Bind1: function() {
    return bindEffect;
  }
};
var bindEffect = {
  bind: bindE,
  Apply0: function() {
    return $lazy_applyEffect(0);
  }
};
var applicativeEffect = {
  pure: pureE,
  Apply0: function() {
    return $lazy_applyEffect(0);
  }
};
var $lazy_functorEffect = /* @__PURE__ */ $runtime_lazy("functorEffect", "Effect", function() {
  return {
    map: liftA1(applicativeEffect)
  };
});
var $lazy_applyEffect = /* @__PURE__ */ $runtime_lazy("applyEffect", "Effect", function() {
  return {
    apply: ap(monadEffect),
    Functor0: function() {
      return $lazy_functorEffect(0);
    }
  };
});
var functorEffect = /* @__PURE__ */ $lazy_functorEffect(20);

// output/Effect.Ref/foreign.js
var _new = function(val) {
  return function() {
    return { value: val };
  };
};
var read = function(ref) {
  return function() {
    return ref.value;
  };
};
var write = function(val) {
  return function(ref) {
    return function() {
      ref.value = val;
    };
  };
};

// output/Effect.Ref/index.js
var $$new = _new;

// output/Control.Monad.Rec.Class/index.js
var Loop = /* @__PURE__ */ function() {
  function Loop2(value0) {
    this.value0 = value0;
  }
  ;
  Loop2.create = function(value0) {
    return new Loop2(value0);
  };
  return Loop2;
}();
var Done = /* @__PURE__ */ function() {
  function Done2(value0) {
    this.value0 = value0;
  }
  ;
  Done2.create = function(value0) {
    return new Done2(value0);
  };
  return Done2;
}();
var tailRecM = function(dict) {
  return dict.tailRecM;
};

// output/Data.Array.ST/foreign.js
var sortByImpl2 = function() {
  function mergeFromTo(compare2, fromOrdering, xs1, xs2, from2, to) {
    var mid;
    var i;
    var j;
    var k;
    var x;
    var y;
    var c;
    mid = from2 + (to - from2 >> 1);
    if (mid - from2 > 1)
      mergeFromTo(compare2, fromOrdering, xs2, xs1, from2, mid);
    if (to - mid > 1)
      mergeFromTo(compare2, fromOrdering, xs2, xs1, mid, to);
    i = from2;
    j = mid;
    k = from2;
    while (i < mid && j < to) {
      x = xs2[i];
      y = xs2[j];
      c = fromOrdering(compare2(x)(y));
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
  return function(compare2) {
    return function(fromOrdering) {
      return function(xs) {
        return function() {
          if (xs.length < 2)
            return xs;
          mergeFromTo(compare2, fromOrdering, xs, xs.slice(0), 0, xs.length);
          return xs;
        };
      };
    };
  };
}();

// output/Data.Foldable/foreign.js
var foldrArray = function(f) {
  return function(init) {
    return function(xs) {
      var acc = init;
      var len = xs.length;
      for (var i = len - 1; i >= 0; i--) {
        acc = f(xs[i])(acc);
      }
      return acc;
    };
  };
};
var foldlArray = function(f) {
  return function(init) {
    return function(xs) {
      var acc = init;
      var len = xs.length;
      for (var i = 0; i < len; i++) {
        acc = f(acc)(xs[i]);
      }
      return acc;
    };
  };
};

// output/Data.Bifunctor/index.js
var bimap = function(dict) {
  return dict.bimap;
};
var lmap = function(dictBifunctor) {
  return function(f) {
    return bimap(dictBifunctor)(f)(identity(categoryFn));
  };
};
var bifunctorTuple = {
  bimap: function(f) {
    return function(g) {
      return function(v) {
        return new Tuple(f(v.value0), g(v.value1));
      };
    };
  }
};

// output/Unsafe.Coerce/foreign.js
var unsafeCoerce2 = function(x) {
  return x;
};

// output/Data.Foldable/index.js
var foldr = function(dict) {
  return dict.foldr;
};
var traverse_ = function(dictApplicative) {
  return function(dictFoldable) {
    return function(f) {
      return foldr(dictFoldable)(function() {
        var $316 = applySecond(dictApplicative.Apply0());
        return function($317) {
          return $316(f($317));
        };
      }())(pure(dictApplicative)(unit));
    };
  };
};
var for_ = function(dictApplicative) {
  return function(dictFoldable) {
    return flip(traverse_(dictApplicative)(dictFoldable));
  };
};
var foldMapDefaultR = function(dictFoldable) {
  return function(dictMonoid) {
    return function(f) {
      return foldr(dictFoldable)(function(x) {
        return function(acc) {
          return append(dictMonoid.Semigroup0())(f(x))(acc);
        };
      })(mempty(dictMonoid));
    };
  };
};
var foldableArray = {
  foldr: foldrArray,
  foldl: foldlArray,
  foldMap: function(dictMonoid) {
    return foldMapDefaultR(foldableArray)(dictMonoid);
  }
};

// output/Data.Traversable/foreign.js
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
  return function(apply2) {
    return function(map2) {
      return function(pure2) {
        return function(f) {
          return function(array) {
            function go2(bot, top2) {
              switch (top2 - bot) {
                case 0:
                  return pure2([]);
                case 1:
                  return map2(array1)(f(array[bot]));
                case 2:
                  return apply2(map2(array2)(f(array[bot])))(f(array[bot + 1]));
                case 3:
                  return apply2(apply2(map2(array3)(f(array[bot])))(f(array[bot + 1])))(f(array[bot + 2]));
                default:
                  var pivot = bot + Math.floor((top2 - bot) / 4) * 2;
                  return apply2(map2(concat2)(go2(bot, pivot)))(go2(pivot, top2));
              }
            }
            return go2(0, array.length);
          };
        };
      };
    };
  };
}();

// output/Data.Int/index.js
var even = function(x) {
  return (x & 1) === 0;
};

// output/Effect.Aff/foreign.js
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
    var size3 = 0;
    var ix = 0;
    var queue = new Array(limit);
    var draining = false;
    function drain() {
      var thunk;
      draining = true;
      while (size3 !== 0) {
        size3--;
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
        if (size3 === limit) {
          tmp = draining;
          drain();
          draining = tmp;
        }
        queue[(ix + size3) % limit] = cb;
        size3++;
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
    var step2 = aff;
    var fail = null;
    var interrupt = null;
    var bhead = null;
    var btail = null;
    var attempts = null;
    var bracketCount = 0;
    var joinId = 0;
    var joins = null;
    var rethrow = true;
    function run3(localRunTick) {
      var tmp, result, attempt;
      while (true) {
        tmp = null;
        result = null;
        attempt = null;
        switch (status) {
          case STEP_BIND:
            status = CONTINUE;
            try {
              step2 = bhead(step2);
              if (btail === null) {
                bhead = null;
              } else {
                bhead = btail._1;
                btail = btail._2;
              }
            } catch (e) {
              status = RETURN;
              fail = util.left(e);
              step2 = null;
            }
            break;
          case STEP_RESULT:
            if (util.isLeft(step2)) {
              status = RETURN;
              fail = step2;
              step2 = null;
            } else if (bhead === null) {
              status = RETURN;
            } else {
              status = STEP_BIND;
              step2 = util.fromRight(step2);
            }
            break;
          case CONTINUE:
            switch (step2.tag) {
              case BIND:
                if (bhead) {
                  btail = new Aff2(CONS, bhead, btail);
                }
                bhead = step2._2;
                status = CONTINUE;
                step2 = step2._1;
                break;
              case PURE:
                if (bhead === null) {
                  status = RETURN;
                  step2 = util.right(step2._1);
                } else {
                  status = STEP_BIND;
                  step2 = step2._1;
                }
                break;
              case SYNC:
                status = STEP_RESULT;
                step2 = runSync(util.left, util.right, step2._1);
                break;
              case ASYNC:
                status = PENDING;
                step2 = runAsync(util.left, step2._1, function(result2) {
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
                      step2 = result2;
                      run3(runTick);
                    });
                  };
                });
                return;
              case THROW:
                status = RETURN;
                fail = util.left(step2._1);
                step2 = null;
                break;
              case CATCH:
                if (bhead === null) {
                  attempts = new Aff2(CONS, step2, attempts, interrupt);
                } else {
                  attempts = new Aff2(CONS, step2, new Aff2(CONS, new Aff2(RESUME, bhead, btail), attempts, interrupt), interrupt);
                }
                bhead = null;
                btail = null;
                status = CONTINUE;
                step2 = step2._1;
                break;
              case BRACKET:
                bracketCount++;
                if (bhead === null) {
                  attempts = new Aff2(CONS, step2, attempts, interrupt);
                } else {
                  attempts = new Aff2(CONS, step2, new Aff2(CONS, new Aff2(RESUME, bhead, btail), attempts, interrupt), interrupt);
                }
                bhead = null;
                btail = null;
                status = CONTINUE;
                step2 = step2._1;
                break;
              case FORK:
                status = STEP_RESULT;
                tmp = Fiber(util, supervisor, step2._2);
                if (supervisor) {
                  supervisor.register(tmp);
                }
                if (step2._1) {
                  tmp.run();
                }
                step2 = util.right(tmp);
                break;
              case SEQ:
                status = CONTINUE;
                step2 = sequential2(util, supervisor, step2._1);
                break;
            }
            break;
          case RETURN:
            bhead = null;
            btail = null;
            if (attempts === null) {
              status = COMPLETED;
              step2 = interrupt || fail || step2;
            } else {
              tmp = attempts._3;
              attempt = attempts._1;
              attempts = attempts._2;
              switch (attempt.tag) {
                case CATCH:
                  if (interrupt && interrupt !== tmp && bracketCount === 0) {
                    status = RETURN;
                  } else if (fail) {
                    status = CONTINUE;
                    step2 = attempt._2(util.fromLeft(fail));
                    fail = null;
                  }
                  break;
                case RESUME:
                  if (interrupt && interrupt !== tmp && bracketCount === 0 || fail) {
                    status = RETURN;
                  } else {
                    bhead = attempt._1;
                    btail = attempt._2;
                    status = STEP_BIND;
                    step2 = util.fromRight(step2);
                  }
                  break;
                case BRACKET:
                  bracketCount--;
                  if (fail === null) {
                    result = util.fromRight(step2);
                    attempts = new Aff2(CONS, new Aff2(RELEASE, attempt._2, result), attempts, tmp);
                    if (interrupt === tmp || bracketCount > 0) {
                      status = CONTINUE;
                      step2 = attempt._3(result);
                    }
                  }
                  break;
                case RELEASE:
                  attempts = new Aff2(CONS, new Aff2(FINALIZED, step2, fail), attempts, interrupt);
                  status = CONTINUE;
                  if (interrupt && interrupt !== tmp && bracketCount === 0) {
                    step2 = attempt._1.killed(util.fromLeft(interrupt))(attempt._2);
                  } else if (fail) {
                    step2 = attempt._1.failed(util.fromLeft(fail))(attempt._2);
                  } else {
                    step2 = attempt._1.completed(util.fromRight(step2))(attempt._2);
                  }
                  fail = null;
                  bracketCount++;
                  break;
                case FINALIZER:
                  bracketCount++;
                  attempts = new Aff2(CONS, new Aff2(FINALIZED, step2, fail), attempts, interrupt);
                  status = CONTINUE;
                  step2 = attempt._1;
                  break;
                case FINALIZED:
                  bracketCount--;
                  status = RETURN;
                  step2 = attempt._1;
                  fail = attempt._2;
                  break;
              }
            }
            break;
          case COMPLETED:
            for (var k in joins) {
              if (joins.hasOwnProperty(k)) {
                rethrow = rethrow && joins[k].rethrow;
                runEff(joins[k].handler(step2));
              }
            }
            joins = null;
            if (interrupt && fail) {
              setTimeout(function() {
                throw util.fromLeft(fail);
              }, 0);
            } else if (util.isLeft(step2) && rethrow) {
              setTimeout(function() {
                if (rethrow) {
                  throw util.fromLeft(step2);
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
    function onComplete(join3) {
      return function() {
        if (status === COMPLETED) {
          rethrow = rethrow && join3.rethrow;
          join3.handler(step2)();
          return function() {
          };
        }
        var jid = joinId++;
        joins = joins || {};
        joins[jid] = join3;
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
            step2 = interrupt;
            run3(runTick);
            break;
          case PENDING:
            if (interrupt === null) {
              interrupt = util.left(error2);
            }
            if (bracketCount === 0) {
              if (status === PENDING) {
                attempts = new Aff2(CONS, new Aff2(FINALIZER, step2(error2)), attempts, interrupt);
              }
              status = RETURN;
              step2 = null;
              fail = null;
              run3(++runTick);
            }
            break;
          default:
            if (interrupt === null) {
              interrupt = util.left(error2);
            }
            if (bracketCount === 0) {
              status = RETURN;
              step2 = null;
              fail = null;
            }
        }
        return canceler;
      };
    }
    function join2(cb) {
      return function() {
        var canceler = onComplete({
          rethrow: false,
          handler: cb
        })();
        if (status === SUSPENDED) {
          run3(runTick);
        }
        return canceler;
      };
    }
    return {
      kill,
      join: join2,
      onComplete,
      isSuspended: function() {
        return status === SUSPENDED;
      },
      run: function() {
        if (status === SUSPENDED) {
          if (!Scheduler.isDraining()) {
            Scheduler.enqueue(function() {
              run3(runTick);
            });
          } else {
            run3(runTick);
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
      var step2 = par2;
      var head = null;
      var tail = null;
      var count = 0;
      var kills2 = {};
      var tmp, kid;
      loop:
        while (true) {
          tmp = null;
          switch (step2.tag) {
            case FORKED:
              if (step2._3 === EMPTY) {
                tmp = fibers[step2._1];
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
              step2 = head._2;
              if (tail === null) {
                head = null;
              } else {
                head = tail._1;
                tail = tail._2;
              }
              break;
            case MAP:
              step2 = step2._2;
              break;
            case APPLY:
            case ALT:
              if (head) {
                tail = new Aff2(CONS, head, tail);
              }
              head = step2;
              step2 = step2._1;
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
    function join2(result, head, tail) {
      var fail, step2, lhs, rhs, tmp, kid;
      if (util.isLeft(result)) {
        fail = result;
        step2 = null;
      } else {
        step2 = result;
        fail = null;
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
            cb(fail || step2)();
            return;
          }
          if (head._3 !== EMPTY) {
            return;
          }
          switch (head.tag) {
            case MAP:
              if (fail === null) {
                head._3 = util.right(head._1(util.fromRight(step2)));
                step2 = head._3;
              } else {
                head._3 = fail;
              }
              break;
            case APPLY:
              lhs = head._1._3;
              rhs = head._2._3;
              if (fail) {
                head._3 = fail;
                tmp = true;
                kid = killId++;
                kills[kid] = kill(early, fail === lhs ? head._2 : head._1, function() {
                  return function() {
                    delete kills[kid];
                    if (tmp) {
                      tmp = false;
                    } else if (tail === null) {
                      join2(fail, null, null);
                    } else {
                      join2(fail, tail._1, tail._2);
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
                step2 = util.right(util.fromRight(lhs)(util.fromRight(rhs)));
                head._3 = step2;
              }
              break;
            case ALT:
              lhs = head._1._3;
              rhs = head._2._3;
              if (lhs === EMPTY && util.isLeft(rhs) || rhs === EMPTY && util.isLeft(lhs)) {
                return;
              }
              if (lhs !== EMPTY && util.isLeft(lhs) && rhs !== EMPTY && util.isLeft(rhs)) {
                fail = step2 === lhs ? rhs : lhs;
                step2 = null;
                head._3 = fail;
              } else {
                head._3 = step2;
                tmp = true;
                kid = killId++;
                kills[kid] = kill(early, step2 === lhs ? head._2 : head._1, function() {
                  return function() {
                    delete kills[kid];
                    if (tmp) {
                      tmp = false;
                    } else if (tail === null) {
                      join2(step2, null, null);
                    } else {
                      join2(step2, tail._1, tail._2);
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
          join2(result, fiber._2._1, fiber._2._2);
        };
      };
    }
    function run3() {
      var status = CONTINUE;
      var step2 = par;
      var head = null;
      var tail = null;
      var tmp, fid;
      loop:
        while (true) {
          tmp = null;
          fid = null;
          switch (status) {
            case CONTINUE:
              switch (step2.tag) {
                case MAP:
                  if (head) {
                    tail = new Aff2(CONS, head, tail);
                  }
                  head = new Aff2(MAP, step2._1, EMPTY, EMPTY);
                  step2 = step2._2;
                  break;
                case APPLY:
                  if (head) {
                    tail = new Aff2(CONS, head, tail);
                  }
                  head = new Aff2(APPLY, EMPTY, step2._2, EMPTY);
                  step2 = step2._1;
                  break;
                case ALT:
                  if (head) {
                    tail = new Aff2(CONS, head, tail);
                  }
                  head = new Aff2(ALT, EMPTY, step2._2, EMPTY);
                  step2 = step2._1;
                  break;
                default:
                  fid = fiberId++;
                  status = RETURN;
                  tmp = step2;
                  step2 = new Aff2(FORKED, fid, new Aff2(CONS, head, tail), EMPTY);
                  tmp = Fiber(util, supervisor, tmp);
                  tmp.onComplete({
                    rethrow: false,
                    handler: resolve(step2)
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
                head._1 = step2;
                status = CONTINUE;
                step2 = head._2;
                head._2 = EMPTY;
              } else {
                head._2 = step2;
                step2 = head;
                if (tail === null) {
                  head = null;
                } else {
                  head = tail._1;
                  tail = tail._2;
                }
              }
          }
        }
      root = step2;
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
    run3();
    return function(killError) {
      return new Aff2(ASYNC, function(killCb) {
        return function() {
          return cancel(killError, killCb);
        };
      });
    };
  }
  function sequential2(util, supervisor, par) {
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
      return Aff.Bind(aff, function(value12) {
        return Aff.Pure(f(value12));
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

// output/Effect.Class/index.js
var liftEffect = function(dict) {
  return dict.liftEffect;
};

// output/Partial.Unsafe/foreign.js
var _unsafePartial = function(f) {
  return f();
};

// output/Partial/foreign.js
var _crashWith = function(msg) {
  throw new Error(msg);
};

// output/Partial/index.js
var crashWith = function() {
  return _crashWith;
};

// output/Partial.Unsafe/index.js
var unsafePartial = _unsafePartial;
var unsafeCrashWith = function(msg) {
  return unsafePartial(function() {
    return crashWith()(msg);
  });
};

// output/Effect.Aff/index.js
var $runtime_lazy2 = function(name15, moduleName, init) {
  var state4 = 0;
  var val;
  return function(lineNumber) {
    if (state4 === 2)
      return val;
    if (state4 === 1)
      throw new ReferenceError(name15 + " was needed before it finished initializing (module " + moduleName + ", line " + lineNumber + ")", moduleName, lineNumber);
    state4 = 1;
    val = init();
    state4 = 2;
    return val;
  };
};
var functorAff = {
  map: _map
};
var ffiUtil = /* @__PURE__ */ function() {
  var unsafeFromRight = function(v) {
    if (v instanceof Right) {
      return v.value0;
    }
    ;
    if (v instanceof Left) {
      return unsafeCrashWith("unsafeFromRight: Left");
    }
    ;
    throw new Error("Failed pattern match at Effect.Aff (line 407, column 21 - line 409, column 54): " + [v.constructor.name]);
  };
  var unsafeFromLeft = function(v) {
    if (v instanceof Left) {
      return v.value0;
    }
    ;
    if (v instanceof Right) {
      return unsafeCrashWith("unsafeFromLeft: Right");
    }
    ;
    throw new Error("Failed pattern match at Effect.Aff (line 402, column 20 - line 404, column 55): " + [v.constructor.name]);
  };
  var isLeft = function(v) {
    if (v instanceof Left) {
      return true;
    }
    ;
    if (v instanceof Right) {
      return false;
    }
    ;
    throw new Error("Failed pattern match at Effect.Aff (line 397, column 12 - line 399, column 21): " + [v.constructor.name]);
  };
  return {
    isLeft,
    fromLeft: unsafeFromLeft,
    fromRight: unsafeFromRight,
    left: Left.create,
    right: Right.create
  };
}();
var makeFiber = function(aff) {
  return _makeFiber(ffiUtil, aff);
};
var launchAff = function(aff) {
  return function __do() {
    var fiber = makeFiber(aff)();
    fiber.run();
    return fiber;
  };
};
var launchAff_ = /* @__PURE__ */ function() {
  var $39 = $$void(functorEffect);
  return function($40) {
    return $39(launchAff($40));
  };
}();
var delay = function(v) {
  return _delay(Right.create, v);
};
var monadAff = {
  Applicative0: function() {
    return applicativeAff;
  },
  Bind1: function() {
    return bindAff;
  }
};
var bindAff = {
  bind: _bind,
  Apply0: function() {
    return $lazy_applyAff(0);
  }
};
var applicativeAff = {
  pure: _pure,
  Apply0: function() {
    return $lazy_applyAff(0);
  }
};
var $lazy_applyAff = /* @__PURE__ */ $runtime_lazy2("applyAff", "Effect.Aff", function() {
  return {
    apply: ap(monadAff),
    Functor0: function() {
      return functorAff;
    }
  };
});
var monadEffectAff = {
  liftEffect: _liftEffect,
  Monad0: function() {
    return monadAff;
  }
};
var monadRecAff = {
  tailRecM: function(k) {
    var go2 = function(a) {
      return bind(bindAff)(k(a))(function(res) {
        if (res instanceof Done) {
          return pure(applicativeAff)(res.value0);
        }
        ;
        if (res instanceof Loop) {
          return go2(res.value0);
        }
        ;
        throw new Error("Failed pattern match at Effect.Aff (line 102, column 7 - line 104, column 23): " + [res.constructor.name]);
      });
    };
    return go2;
  },
  Monad0: function() {
    return monadAff;
  }
};

// output/Effect.Aff.Class/index.js
var monadAffAff = {
  liftAff: /* @__PURE__ */ identity(categoryFn),
  MonadEffect0: function() {
    return monadEffectAff;
  }
};
var liftAff = function(dict) {
  return dict.liftAff;
};

// output/Data.List.Types/index.js
var Nil = /* @__PURE__ */ function() {
  function Nil2() {
  }
  ;
  Nil2.value = new Nil2();
  return Nil2;
}();
var Cons = /* @__PURE__ */ function() {
  function Cons2(value0, value1) {
    this.value0 = value0;
    this.value1 = value1;
  }
  ;
  Cons2.create = function(value0) {
    return function(value1) {
      return new Cons2(value0, value1);
    };
  };
  return Cons2;
}();

// output/Data.List/index.js
var reverse2 = /* @__PURE__ */ function() {
  var go2 = function($copy_acc) {
    return function($copy_v) {
      var $tco_var_acc = $copy_acc;
      var $tco_done = false;
      var $tco_result;
      function $tco_loop(acc, v) {
        if (v instanceof Nil) {
          $tco_done = true;
          return acc;
        }
        ;
        if (v instanceof Cons) {
          $tco_var_acc = new Cons(v.value0, acc);
          $copy_v = v.value1;
          return;
        }
        ;
        throw new Error("Failed pattern match at Data.List (line 368, column 3 - line 368, column 19): " + [acc.constructor.name, v.constructor.name]);
      }
      ;
      while (!$tco_done) {
        $tco_result = $tco_loop($tco_var_acc, $copy_v);
      }
      ;
      return $tco_result;
    };
  };
  return go2(Nil.value);
}();

// output/Data.CatQueue/index.js
var CatQueue = /* @__PURE__ */ function() {
  function CatQueue2(value0, value1) {
    this.value0 = value0;
    this.value1 = value1;
  }
  ;
  CatQueue2.create = function(value0) {
    return function(value1) {
      return new CatQueue2(value0, value1);
    };
  };
  return CatQueue2;
}();
var uncons = function($copy_v) {
  var $tco_done = false;
  var $tco_result;
  function $tco_loop(v) {
    if (v.value0 instanceof Nil && v.value1 instanceof Nil) {
      $tco_done = true;
      return Nothing.value;
    }
    ;
    if (v.value0 instanceof Nil) {
      $copy_v = new CatQueue(reverse2(v.value1), Nil.value);
      return;
    }
    ;
    if (v.value0 instanceof Cons) {
      $tco_done = true;
      return new Just(new Tuple(v.value0.value0, new CatQueue(v.value0.value1, v.value1)));
    }
    ;
    throw new Error("Failed pattern match at Data.CatQueue (line 82, column 1 - line 82, column 63): " + [v.constructor.name]);
  }
  ;
  while (!$tco_done) {
    $tco_result = $tco_loop($copy_v);
  }
  ;
  return $tco_result;
};
var snoc = function(v) {
  return function(a) {
    return new CatQueue(v.value0, new Cons(a, v.value1));
  };
};
var $$null = function(v) {
  if (v.value0 instanceof Nil && v.value1 instanceof Nil) {
    return true;
  }
  ;
  return false;
};
var empty2 = /* @__PURE__ */ function() {
  return new CatQueue(Nil.value, Nil.value);
}();

// output/Data.CatList/index.js
var CatNil = /* @__PURE__ */ function() {
  function CatNil2() {
  }
  ;
  CatNil2.value = new CatNil2();
  return CatNil2;
}();
var CatCons = /* @__PURE__ */ function() {
  function CatCons2(value0, value1) {
    this.value0 = value0;
    this.value1 = value1;
  }
  ;
  CatCons2.create = function(value0) {
    return function(value1) {
      return new CatCons2(value0, value1);
    };
  };
  return CatCons2;
}();
var link = function(v) {
  return function(v1) {
    if (v instanceof CatNil) {
      return v1;
    }
    ;
    if (v1 instanceof CatNil) {
      return v;
    }
    ;
    if (v instanceof CatCons) {
      return new CatCons(v.value0, snoc(v.value1)(v1));
    }
    ;
    throw new Error("Failed pattern match at Data.CatList (line 108, column 1 - line 108, column 54): " + [v.constructor.name, v1.constructor.name]);
  };
};
var foldr2 = function(k) {
  return function(b) {
    return function(q) {
      var foldl2 = function($copy_v) {
        return function($copy_c) {
          return function($copy_v1) {
            var $tco_var_v = $copy_v;
            var $tco_var_c = $copy_c;
            var $tco_done = false;
            var $tco_result;
            function $tco_loop(v, c, v1) {
              if (v1 instanceof Nil) {
                $tco_done = true;
                return c;
              }
              ;
              if (v1 instanceof Cons) {
                $tco_var_v = v;
                $tco_var_c = v(c)(v1.value0);
                $copy_v1 = v1.value1;
                return;
              }
              ;
              throw new Error("Failed pattern match at Data.CatList (line 124, column 3 - line 124, column 59): " + [v.constructor.name, c.constructor.name, v1.constructor.name]);
            }
            ;
            while (!$tco_done) {
              $tco_result = $tco_loop($tco_var_v, $tco_var_c, $copy_v1);
            }
            ;
            return $tco_result;
          };
        };
      };
      var go2 = function($copy_xs) {
        return function($copy_ys) {
          var $tco_var_xs = $copy_xs;
          var $tco_done1 = false;
          var $tco_result;
          function $tco_loop(xs, ys) {
            var v = uncons(xs);
            if (v instanceof Nothing) {
              $tco_done1 = true;
              return foldl2(function(x) {
                return function(i) {
                  return i(x);
                };
              })(b)(ys);
            }
            ;
            if (v instanceof Just) {
              $tco_var_xs = v.value0.value1;
              $copy_ys = new Cons(k(v.value0.value0), ys);
              return;
            }
            ;
            throw new Error("Failed pattern match at Data.CatList (line 120, column 14 - line 122, column 67): " + [v.constructor.name]);
          }
          ;
          while (!$tco_done1) {
            $tco_result = $tco_loop($tco_var_xs, $copy_ys);
          }
          ;
          return $tco_result;
        };
      };
      return go2(q)(Nil.value);
    };
  };
};
var uncons2 = function(v) {
  if (v instanceof CatNil) {
    return Nothing.value;
  }
  ;
  if (v instanceof CatCons) {
    return new Just(new Tuple(v.value0, function() {
      var $45 = $$null(v.value1);
      if ($45) {
        return CatNil.value;
      }
      ;
      return foldr2(link)(CatNil.value)(v.value1);
    }()));
  }
  ;
  throw new Error("Failed pattern match at Data.CatList (line 99, column 1 - line 99, column 61): " + [v.constructor.name]);
};
var empty3 = /* @__PURE__ */ function() {
  return CatNil.value;
}();
var append2 = link;
var semigroupCatList = {
  append: append2
};
var snoc2 = function(cat) {
  return function(a) {
    return append2(cat)(new CatCons(a, empty2));
  };
};

// output/Control.Monad.Free/index.js
var $runtime_lazy3 = function(name15, moduleName, init) {
  var state4 = 0;
  var val;
  return function(lineNumber) {
    if (state4 === 2)
      return val;
    if (state4 === 1)
      throw new ReferenceError(name15 + " was needed before it finished initializing (module " + moduleName + ", line " + lineNumber + ")", moduleName, lineNumber);
    state4 = 1;
    val = init();
    state4 = 2;
    return val;
  };
};
var Free = /* @__PURE__ */ function() {
  function Free2(value0, value1) {
    this.value0 = value0;
    this.value1 = value1;
  }
  ;
  Free2.create = function(value0) {
    return function(value1) {
      return new Free2(value0, value1);
    };
  };
  return Free2;
}();
var Return = /* @__PURE__ */ function() {
  function Return2(value0) {
    this.value0 = value0;
  }
  ;
  Return2.create = function(value0) {
    return new Return2(value0);
  };
  return Return2;
}();
var Bind = /* @__PURE__ */ function() {
  function Bind2(value0, value1) {
    this.value0 = value0;
    this.value1 = value1;
  }
  ;
  Bind2.create = function(value0) {
    return function(value1) {
      return new Bind2(value0, value1);
    };
  };
  return Bind2;
}();
var toView = function($copy_v) {
  var $tco_done = false;
  var $tco_result;
  function $tco_loop(v) {
    var runExpF = function(v22) {
      return v22;
    };
    var concatF = function(v22) {
      return function(r) {
        return new Free(v22.value0, append(semigroupCatList)(v22.value1)(r));
      };
    };
    if (v.value0 instanceof Return) {
      var v2 = uncons2(v.value1);
      if (v2 instanceof Nothing) {
        $tco_done = true;
        return new Return(v.value0.value0);
      }
      ;
      if (v2 instanceof Just) {
        $copy_v = concatF(runExpF(v2.value0.value0)(v.value0.value0))(v2.value0.value1);
        return;
      }
      ;
      throw new Error("Failed pattern match at Control.Monad.Free (line 227, column 7 - line 231, column 64): " + [v2.constructor.name]);
    }
    ;
    if (v.value0 instanceof Bind) {
      $tco_done = true;
      return new Bind(v.value0.value0, function(a) {
        return concatF(v.value0.value1(a))(v.value1);
      });
    }
    ;
    throw new Error("Failed pattern match at Control.Monad.Free (line 225, column 3 - line 233, column 56): " + [v.value0.constructor.name]);
  }
  ;
  while (!$tco_done) {
    $tco_result = $tco_loop($copy_v);
  }
  ;
  return $tco_result;
};
var runFreeM = function(dictFunctor) {
  return function(dictMonadRec) {
    return function(k) {
      var go2 = function(f) {
        var v = toView(f);
        if (v instanceof Return) {
          return map(dictMonadRec.Monad0().Bind1().Apply0().Functor0())(Done.create)(pure(dictMonadRec.Monad0().Applicative0())(v.value0));
        }
        ;
        if (v instanceof Bind) {
          return map(dictMonadRec.Monad0().Bind1().Apply0().Functor0())(Loop.create)(k(map(dictFunctor)(v.value1)(v.value0)));
        }
        ;
        throw new Error("Failed pattern match at Control.Monad.Free (line 194, column 10 - line 196, column 37): " + [v.constructor.name]);
      };
      return tailRecM(dictMonadRec)(go2);
    };
  };
};
var fromView = function(f) {
  return new Free(f, empty3);
};
var freeMonad = {
  Applicative0: function() {
    return freeApplicative;
  },
  Bind1: function() {
    return freeBind;
  }
};
var freeFunctor = {
  map: function(k) {
    return function(f) {
      return bindFlipped(freeBind)(function() {
        var $119 = pure(freeApplicative);
        return function($120) {
          return $119(k($120));
        };
      }())(f);
    };
  }
};
var freeBind = {
  bind: function(v) {
    return function(k) {
      return new Free(v.value0, snoc2(v.value1)(k));
    };
  },
  Apply0: function() {
    return $lazy_freeApply(0);
  }
};
var freeApplicative = {
  pure: function($121) {
    return fromView(Return.create($121));
  },
  Apply0: function() {
    return $lazy_freeApply(0);
  }
};
var $lazy_freeApply = /* @__PURE__ */ $runtime_lazy3("freeApply", "Control.Monad.Free", function() {
  return {
    apply: ap(freeMonad),
    Functor0: function() {
      return freeFunctor;
    }
  };
});
var liftF = function(f) {
  return fromView(new Bind(f, function() {
    var $122 = pure(freeApplicative);
    return function($123) {
      return $122($123);
    };
  }()));
};

// output/Pha.App.Internal/foreign.js
var TEXT_NODE = 3;
var merge = (a, b) => Object.assign({}, a, b);
var compose2 = (f, g) => f && g ? (x) => f(g(x)) : f || g;
var patchProperty = (node, key2, oldValue, newValue, listener, isSvg, mapf) => {
  if (key2 === "style") {
    for (let k in merge(oldValue, newValue)) {
      oldValue = newValue == null || newValue[k] == null ? "" : newValue[k];
      if (k[0] === "-") {
        node[key2].setProperty(k, oldValue);
      } else {
        node[key2][k] = oldValue;
      }
    }
  } else if (key2[0] === "o" && key2[1] === "n") {
    const key22 = key2.slice(2);
    if (!node.actions)
      node.actions = {};
    node.actions[key22] = mapf && newValue ? mapf(newValue) : newValue;
    if (!newValue) {
      node.removeEventListener(key22, listener);
    } else if (!oldValue) {
      node.addEventListener(key22, listener);
    }
  } else if (!isSvg && key2 !== "list" && key2 in node) {
    node[key2] = newValue;
  } else if (newValue == null || newValue === false || key2 === "class" && !newValue) {
    node.removeAttribute(key2);
  } else {
    node.setAttribute(key2, newValue);
  }
};
var createNode = (vnode, listener, isSvg, mapf) => {
  const node = vnode.type === TEXT_NODE ? document.createTextNode(vnode.tag) : (isSvg = isSvg || vnode.tag === "svg") ? document.createElementNS("http://www.w3.org/2000/svg", vnode.tag) : document.createElement(vnode.tag);
  const props = vnode.props;
  const mapf2 = compose2(mapf, vnode.mapf);
  for (let k in props) {
    patchProperty(node, k, null, props[k], listener, isSvg, mapf2);
  }
  for (let i = 0, len = vnode.children.length; i < len; i++) {
    node.appendChild(createNode(getVNode(vnode.children[i])[1], listener, isSvg, mapf2));
  }
  vnode.node = node;
  return node;
};
var getKey = (keyednode) => keyednode && keyednode[0];
var patch = (parent2, node, oldVNode, newVNode, listener, isSvg, mapf) => {
  if (oldVNode === newVNode) {
  } else if (oldVNode != null && oldVNode.type === TEXT_NODE && newVNode.type === TEXT_NODE) {
    if (oldVNode.tag !== newVNode.tag)
      node.nodeValue = newVNode.tag;
  } else if (oldVNode == null || oldVNode.tag !== newVNode.tag) {
    node = parent2.insertBefore(createNode(newVNode, listener, isSvg, mapf), node);
    if (oldVNode && oldVNode.node) {
      parent2.removeChild(oldVNode.node);
    }
  } else {
    const oldVProps = oldVNode.props;
    const newVProps = newVNode.props;
    const oldVKids = oldVNode.children;
    const newVKids = newVNode.children;
    let oldHead = 0;
    let newHead = 0;
    let oldTail = oldVKids.length - 1;
    let newTail = newVKids.length - 1;
    mapf = compose2(mapf, newVNode.mapf);
    isSvg = isSvg || newVNode.tag === "svg";
    for (let i in merge(oldVProps, newVProps)) {
      if ((i === "value" || i === "selected" || i === "checked" ? node[i] : oldVProps[i]) !== newVProps[i]) {
        patchProperty(node, i, oldVProps[i], newVProps[i], listener, isSvg, mapf);
      }
    }
    if (!newVNode.keyed) {
      for (let i = 0; i <= oldTail && i <= newTail; i++) {
        const oldVNode2 = oldVKids[i][1];
        const newVNode2 = getVNode(newVKids[i], oldVNode2)[1];
        patch(node, oldVNode2.node, oldVNode2, newVNode2, listener, isSvg, mapf);
      }
      for (let i = oldTail + 1; i <= newTail; i++) {
        const newVNode2 = getVNode(newVKids[i], oldVNode)[1];
        node.appendChild(createNode(newVNode2, listener, isSvg, mapf));
      }
      for (let i = newTail + 1; i <= oldTail; i++) {
        node.removeChild(oldVKids[i][1].node);
      }
    } else {
      while (newHead <= newTail && oldHead <= oldTail) {
        const [oldKey, oldVNode2] = oldVKids[oldHead];
        if (oldKey !== newVKids[newHead][0])
          break;
        const newKNode = getVNode(newVKids[newHead], oldVNode2);
        patch(node, oldVNode2.node, oldVNode2, newKNode[1], listener, isSvg, mapf);
        newHead++;
        oldHead++;
      }
      while (newHead <= newTail && oldHead <= oldTail) {
        const [oldKey, oldVNode2] = oldVKids[oldTail];
        if (oldKey !== newVKids[newTail][0])
          break;
        const newKNode = getVNode(newVKids[newTail], oldVNode2);
        patch(node, oldVNode2.node, oldVNode2, newKNode[1], listener, isSvg, mapf);
        newTail--;
        oldTail--;
      }
      if (oldHead > oldTail) {
        while (newHead <= newTail) {
          const newVNode2 = getVNode(newVKids[newHead])[1];
          node.insertBefore(createNode(newVNode2, listener, isSvg, mapf), oldVKids[oldHead] && oldVKids[oldHead][1].node);
          newHead++;
        }
      } else if (newHead > newTail) {
        while (oldHead <= oldTail) {
          node.removeChild(oldVKids[oldHead][1].node);
          oldHead++;
        }
      } else {
        const keyed2 = {};
        const newKeyed = {};
        for (let i = oldHead; i <= oldTail; i++) {
          keyed2[oldVKids[i][0]] = oldVKids[i][1];
        }
        while (newHead <= newTail) {
          const [oldKey, oldVKid] = oldVKids[oldHead];
          const [newKey, newVKid] = getVNode(newVKids[newHead], oldVKid);
          if (newKeyed[oldKey] || newKey === getKey(oldVKids[oldHead + 1])) {
            oldHead++;
            continue;
          }
          if (oldKey === newKey) {
            patch(node, oldVKid.node, oldVKid, newVKid, listener, isSvg, mapf);
            newKeyed[newKey] = true;
            oldHead++;
          } else {
            const vkid = keyed2[newKey];
            if (vkid != null) {
              patch(node, node.insertBefore(vkid.node, oldVKid.node), vkid, newVKids[newHead][1], listener, isSvg, mapf);
              newKeyed[newKey] = true;
            } else {
              patch(node, oldVKid.node, null, newVKids[newHead][1], listener, isSvg, mapf);
            }
          }
          newHead++;
        }
        for (let i in keyed2) {
          if (!newKeyed[i]) {
            node.removeChild(keyed2[i].node);
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
var evalMemo = (f, memo) => memo.reduce((g, v) => g(v), f);
var getVNode = (newVNode, oldVNode) => {
  if (typeof newVNode[1].type === "function") {
    if (!oldVNode || oldVNode.memo == null || propsChanged(oldVNode.memo, newVNode[1].memo)) {
      oldVNode = copyVNode(evalMemo(newVNode[1].type, newVNode[1].memo));
      oldVNode.memo = newVNode[1].memo;
    }
    newVNode[1] = oldVNode;
  }
  return newVNode;
};
var copyVNode = (vnode) => Object.assign({}, vnode, { children: vnode.children && vnode.children.map(([k, v]) => [k, copyVNode(v)]) });
var getAction = (target5) => (type) => () => target5.actions[type];
var unsafePatch = (parent2) => (node) => (oldVDom) => (newVDom) => (listener) => () => patch(parent2, node, oldVDom, newVDom, (e) => listener(e)());

// output/Pha.Html.Core/foreign.js
var _h = (tag, ps, children2, keyed2 = false) => {
  const style2 = {};
  const props = { style: style2 };
  const vdom = { tag, children: children2, props, node: null, keyed: keyed2 };
  const n = ps.length;
  for (let i = 0; i < n; i++) {
    const [t, k, v] = ps[i];
    if (t == 1)
      props[k] = v;
    else if (t === 2)
      props.class = (props.class ? props.class + " " : "") + k;
    else if (t === 3)
      style2[k] = v;
  }
  return vdom;
};
var elem2 = (tag) => (ps) => (children2) => _h(tag, ps, children2.map((v) => [null, v]));
var keyed = (tag) => (ps) => (children2) => _h(tag, ps, children2.map((v) => [v.value0, v.value1]), true);
var createTextVNode = (text6) => ({
  tag: text6,
  props: {},
  children: [],
  type: 3
});
var class_ = (cls) => [2, cls];
var noProp = [-1];
var unsafeOnWithEffect = (k) => (v) => [1, "on" + k, v];
var text = createTextVNode;
var lazy = (view2) => (val) => ({ memo: [val], type: view2 });

// output/Web.Event.Event/foreign.js
function _currentTarget(e) {
  return e.currentTarget;
}
function type_(e) {
  return e.type;
}

// output/Data.Nullable/foreign.js
function nullable(a, r, f) {
  return a == null ? r : f(a);
}

// output/Data.Nullable/index.js
var toMaybe = function(n) {
  return nullable(n, Nothing.value, Just.create);
};

// output/Web.Event.Event/index.js
var currentTarget = function($4) {
  return toMaybe(_currentTarget($4));
};

// output/Pha.Html.Core/index.js
var class$prime = function(c) {
  return function(b) {
    if (b) {
      return class_(c);
    }
    ;
    return noProp;
  };
};

// output/Pha.Update/index.js
var State = /* @__PURE__ */ function() {
  function State2(value0) {
    this.value0 = value0;
  }
  ;
  State2.create = function(value0) {
    return new State2(value0);
  };
  return State2;
}();
var Lift = /* @__PURE__ */ function() {
  function Lift2(value0) {
    this.value0 = value0;
  }
  ;
  Lift2.create = function(value0) {
    return new Lift2(value0);
  };
  return Lift2;
}();
var Update = function(x) {
  return x;
};
var monadUpdate = freeMonad;
var monadStateUpdate = {
  state: function($19) {
    return Update(liftF(State.create($19)));
  },
  Monad0: function() {
    return monadUpdate;
  }
};
var monadEffectUpdate = function(dictMonadEffect) {
  return {
    liftEffect: function() {
      var $20 = liftEffect(dictMonadEffect);
      return function($21) {
        return Update(liftF(Lift.create($20($21))));
      };
    }(),
    Monad0: function() {
      return monadUpdate;
    }
  };
};
var monadAffUpdate = function(dictMonadAff) {
  return {
    liftAff: function() {
      var $22 = liftAff(dictMonadAff);
      return function($23) {
        return Update(liftF(Lift.create($22($23))));
      };
    }(),
    MonadEffect0: function() {
      return monadEffectUpdate(dictMonadAff.MonadEffect0());
    }
  };
};
var functorUpdateF = function(dictFunctor) {
  return {
    map: function(f) {
      return function(v) {
        if (v instanceof State) {
          return new State(function() {
            var $24 = lmap(bifunctorTuple)(f);
            return function($25) {
              return $24(v.value0($25));
            };
          }());
        }
        ;
        if (v instanceof Lift) {
          return new Lift(map(dictFunctor)(f)(v.value0));
        }
        ;
        throw new Error("Failed pattern match at Pha.Update (line 21, column 1 - line 23, column 36): " + [f.constructor.name, v.constructor.name]);
      };
    }
  };
};
var bindUpdate = freeBind;
var delay2 = function(dictMonadAff) {
  return function(ms) {
    return liftAff(monadAffUpdate(dictMonadAff))(delay(ms));
  };
};

// output/Unsafe.Reference/foreign.js
function reallyUnsafeRefEq(a) {
  return function(b) {
    return a === b;
  };
}

// output/Unsafe.Reference/index.js
var unsafeRefEq = reallyUnsafeRefEq;

// output/Web.DOM.Element/foreign.js
var getProp = function(name15) {
  return function(doctype) {
    return doctype[name15];
  };
};
var _namespaceURI = getProp("namespaceURI");
var _prefix = getProp("prefix");
var localName = getProp("localName");
var tagName = getProp("tagName");

// output/Web.DOM.ParentNode/foreign.js
var getEffProp = function(name15) {
  return function(node) {
    return function() {
      return node[name15];
    };
  };
};
var children = getEffProp("children");
var _firstElementChild = getEffProp("firstElementChild");
var _lastElementChild = getEffProp("lastElementChild");
var childElementCount = getEffProp("childElementCount");
function _querySelector(selector) {
  return function(node) {
    return function() {
      return node.querySelector(selector);
    };
  };
}

// output/Web.DOM.ParentNode/index.js
var querySelector = function(qs) {
  var $0 = map(functorEffect)(toMaybe);
  var $1 = _querySelector(qs);
  return function($2) {
    return $0($1($2));
  };
};

// output/Web.Internal.FFI/foreign.js
function _unsafeReadProtoTagged(nothing, just, name15, value12) {
  if (typeof window !== "undefined") {
    var ty = window[name15];
    if (ty != null && value12 instanceof ty) {
      return just(value12);
    }
  }
  var obj = value12;
  while (obj != null) {
    var proto = Object.getPrototypeOf(obj);
    var constructorName = proto.constructor.name;
    if (constructorName === name15) {
      return just(value12);
    } else if (constructorName === "Object") {
      return nothing;
    }
    obj = proto;
  }
  return nothing;
}

// output/Web.Internal.FFI/index.js
var unsafeReadProtoTagged = function(name15) {
  return function(value12) {
    return _unsafeReadProtoTagged(Nothing.value, Just.create, name15, value12);
  };
};

// output/Web.DOM.Element/index.js
var toNode = unsafeCoerce2;

// output/Web.DOM.Node/foreign.js
var getEffProp2 = function(name15) {
  return function(node) {
    return function() {
      return node[name15];
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

// output/Web.DOM.Node/index.js
var parentNode = /* @__PURE__ */ function() {
  var $2 = map(functorEffect)(toMaybe);
  return function($3) {
    return $2(_parentNode($3));
  };
}();

// output/Web.HTML/foreign.js
var windowImpl = function() {
  return window;
};

// output/Web.HTML.HTMLDocument/index.js
var toParentNode = unsafeCoerce2;

// output/Web.HTML.Window/foreign.js
function document2(window2) {
  return function() {
    return window2.document;
  };
}

// output/Web.HTML.Window/index.js
var toEventTarget = unsafeCoerce2;

// output/Pha.App/index.js
var $runtime_lazy4 = function(name15, moduleName, init) {
  var state4 = 0;
  var val;
  return function(lineNumber) {
    if (state4 === 2)
      return val;
    if (state4 === 1)
      throw new ReferenceError(name15 + " was needed before it finished initializing (module " + moduleName + ", line " + lineNumber + ")", moduleName, lineNumber);
    state4 = 1;
    val = init();
    state4 = 2;
    return val;
  };
};
var interpret = function(dictMonad) {
  return function(v) {
    return function($$eval) {
      return function(v1) {
        var go2 = function(v2) {
          if (v2 instanceof State) {
            return bind(bindAff)(liftEffect(monadEffectAff)(v.get))(function(st) {
              var v3 = v2.value0(st);
              return discard(discardUnit)(bindAff)(liftEffect(monadEffectAff)(v.put(v3.value1)))(function() {
                return pure(applicativeAff)(v3.value0);
              });
            });
          }
          ;
          if (v2 instanceof Lift) {
            return $$eval(v2.value0);
          }
          ;
          throw new Error("Failed pattern match at Pha.App (line 110, column 5 - line 114, column 15): " + [v2.constructor.name]);
        };
        return runFreeM(functorUpdateF(dictMonad.Bind1().Apply0().Functor0()))(monadRecAff)(go2)(v1);
      };
    };
  };
};
var app$prime = function(v) {
  var go2 = function(state4) {
    return function(lock) {
      return function(node) {
        return function(vdom) {
          var getState = read(state4);
          var setState = function(newState) {
            return function __do() {
              var oldState = read(state4)();
              return unless(applicativeEffect)(unsafeRefEq(oldState)(newState))(function __do2() {
                write(newState)(state4)();
                var lock1 = read(lock)();
                return unless(applicativeEffect)(lock1)(function __do3() {
                  write(true)(lock)();
                  return render(v.view(newState))();
                })();
              })();
            };
          };
          var render = function(newVDom) {
            return function __do() {
              write(false)(lock)();
              var oldVDom = read(vdom)();
              var node1 = read(node)();
              var pnode = parentNode(node1)();
              if (pnode instanceof Nothing) {
                return unit;
              }
              ;
              if (pnode instanceof Just) {
                var vdom2 = copyVNode(newVDom);
                var node2 = unsafePatch(pnode.value0)(node1)(oldVDom)(vdom2)(listener)();
                write(node2)(node)();
                return write(vdom2)(vdom)();
              }
              ;
              throw new Error("Failed pattern match at Pha.App (line 59, column 17 - line 65, column 45): " + [pnode.constructor.name]);
            };
          };
          var listener = function(e) {
            var v1 = type_(e);
            var v2 = currentTarget(e);
            if (v2 instanceof Nothing) {
              return pure(applicativeEffect)(unit);
            }
            ;
            if (v2 instanceof Just) {
              return function __do() {
                var fn = getAction(v2.value0)(v1)();
                return dispatchEvent2(e)(fn)();
              };
            }
            ;
            throw new Error("Failed pattern match at Pha.App (line 98, column 13 - line 102, column 39): " + [v2.constructor.name]);
          };
          var dispatchEvent2 = function(ev) {
            return function(handler) {
              return function __do() {
                var msg = handler(ev)();
                if (msg instanceof Nothing) {
                  return unit;
                }
                ;
                if (msg instanceof Just) {
                  return $lazy_dispatch(94)(msg.value0)();
                }
                ;
                throw new Error("Failed pattern match at Pha.App (line 92, column 25 - line 94, column 48): " + [msg.constructor.name]);
              };
            };
          };
          var $lazy_dispatch = $runtime_lazy4("dispatch", "Pha.App", function() {
            return v.update({
              get: getState,
              put: function(s) {
                return setState(s);
              }
            });
          });
          var dispatch = $lazy_dispatch(85);
          return function __do() {
            render(v.view(v.init.state))();
            for_(applicativeEffect)(foldableArray)(v.subscriptions)(function(v1) {
              return v1(dispatch);
            })();
            if (v.init.action instanceof Just) {
              return dispatch(v.init.action.value0)();
            }
            ;
            if (v.init.action instanceof Nothing) {
              return unit;
            }
            ;
            throw new Error("Failed pattern match at Pha.App (line 49, column 9 - line 51, column 32): " + [v.init.action.constructor.name]);
          };
        };
      };
    };
  };
  return function __do() {
    var parentNode2 = mapFlipped(functorEffect)(bind(bindEffect)(windowImpl)(document2))(toParentNode)();
    var selected2 = map(functorEffect)(map(functorMaybe)(toNode))(querySelector(v.selector)(parentNode2))();
    if (selected2 instanceof Nothing) {
      return unit;
    }
    ;
    if (selected2 instanceof Just) {
      var state4 = $$new(v.init.state)();
      var lock = $$new(false)();
      var node = $$new(selected2.value0)();
      var vdom = $$new(text(""))();
      return go2(state4)(lock)(node)(vdom)();
    }
    ;
    throw new Error("Failed pattern match at Pha.App (line 36, column 5 - line 44, column 36): " + [selected2.constructor.name]);
  };
};
var app = function(dictMonad) {
  return function(v) {
    var update$prime = function(helpers) {
      return function(msg) {
        return launchAff_(interpret(dictMonad)(helpers)(v["eval"])(v.update(msg)));
      };
    };
    return app$prime({
      init: v.init,
      view: v.view,
      subscriptions: v.subscriptions,
      selector: v.selector,
      update: update$prime
    });
  };
};

// output/Pha.Html.Elements/index.js
var span2 = /* @__PURE__ */ elem2("span");
var hr = function(attrs) {
  return elem2("hr")(attrs)([]);
};
var h3 = /* @__PURE__ */ elem2("h3");
var div2 = /* @__PURE__ */ elem2("div");
var button = /* @__PURE__ */ elem2("button");

// output/Web.PointerEvent.PointerEvent/index.js
var fromEvent = /* @__PURE__ */ unsafeReadProtoTagged("PointerEvent");

// output/Pha.Html.Events/index.js
var on2 = unsafeOnWithEffect;
var onClick = function(handler) {
  return on2("click")(function(ev) {
    return pure(applicativeEffect)(map(functorMaybe)(handler)(fromEvent(ev)));
  });
};

// output/Web.Event.EventTarget/foreign.js
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
      return function(target5) {
        return function() {
          return target5.addEventListener(type, listener, useCapture);
        };
      };
    };
  };
}

// output/Web.UIEvent.KeyboardEvent/foreign.js
function key(e) {
  return e.key;
}

// output/Web.UIEvent.KeyboardEvent/index.js
var fromEvent3 = /* @__PURE__ */ unsafeReadProtoTagged("KeyboardEvent");

// output/Pha.Subscriptions/index.js
var makeSubscription = function(sub2) {
  return function(d) {
    return function(dispatch) {
      return sub2(dispatch)(d);
    };
  };
};
var on3 = function(n) {
  return function(d) {
    var handleEvent = function(dispatch) {
      return function(decoder) {
        return function(ev) {
          return function __do() {
            var v = decoder(ev)();
            if (v instanceof Nothing) {
              return unit;
            }
            ;
            if (v instanceof Just) {
              return dispatch(v.value0)();
            }
            ;
            throw new Error("Failed pattern match at Pha.Subscriptions (line 26, column 24 - line 28, column 36): " + [v.constructor.name]);
          };
        };
      };
    };
    var fn = function(dispatch) {
      return function(v) {
        return function __do() {
          var listener = eventListener(handleEvent(dispatch)(v.decoder))();
          return bind(bindEffect)(mapFlipped(functorEffect)(windowImpl)(toEventTarget))(addEventListener(v.name)(listener)(false))();
        };
      };
    };
    return makeSubscription(fn)({
      name: n,
      decoder: d
    });
  };
};
var onKeyDown = function(f) {
  return on3("keydown")(function(ev) {
    return pure(applicativeEffect)(bindFlipped(bindMaybe)(f)(map(functorMaybe)(key)(fromEvent3(ev))));
  });
};

// output/Example.Counter2/index.js
var Increment = /* @__PURE__ */ function() {
  function Increment2() {
  }
  ;
  Increment2.value = new Increment2();
  return Increment2;
}();
var DelayedIncrement = /* @__PURE__ */ function() {
  function DelayedIncrement2() {
  }
  ;
  DelayedIncrement2.value = new DelayedIncrement2();
  return DelayedIncrement2;
}();
var update = function(v) {
  if (v instanceof Increment) {
    return modify_(monadStateUpdate)(function(v1) {
      return v1 + 1 | 0;
    });
  }
  ;
  if (v instanceof DelayedIncrement) {
    return discard(discardUnit)(bindUpdate)(delay2(monadAffAff)(1e3))(function() {
      return modify_(monadStateUpdate)(function(v1) {
        return v1 + 1 | 0;
      });
    });
  }
  ;
  throw new Error("Failed pattern match at Example.Counter2 (line 27, column 1 - line 27, column 37): " + [v.constructor.name]);
};
var state3 = 0;
var spanCounter = function(v) {
  return span2([])([text(show(showInt)(v))]);
};
var view = function(counter) {
  return div2([])([div2([class_("counter")])([text(show(showInt)(counter))]), button([onClick(function(v) {
    return Increment.value;
  })])([text("Increment")]), button([onClick(function(v) {
    return DelayedIncrement.value;
  })])([text("Delayed Increment")]), div2([])([span2([])([text("green when the counter is even")]), div2([class_("box"), class$prime("even")(even(counter))])([])]), h3([])([text("press I to increment the counter")]), hr([]), h3([])([text("keyed")]), keyed("div")([])(append(semigroupArray)(mapFlipped(functorArray)(range(0)(mod(euclideanRingInt)(counter)(4)))(function(i) {
    return new Tuple(show(showInt)(i), text(show(showInt)(i)));
  }))(append(semigroupArray)([new Tuple("test", text("test"))])(mapFlipped(functorArray)(range(0)(mod(euclideanRingInt)(counter)(4)))(function(i) {
    return new Tuple(show(showInt)(i), text(show(showInt)(i)));
  })))), hr([]), h3([])([text("non keyed")]), div2([])(append(semigroupArray)(mapFlipped(functorArray)(range(0)(mod(euclideanRingInt)(counter)(4)))(function(i) {
    return text(show(showInt)(i));
  }))(append(semigroupArray)([text("test")])(mapFlipped(functorArray)(range(0)(mod(euclideanRingInt)(counter)(4)))(function(i) {
    return text(show(showInt)(i));
  })))), hr([]), h3([])([text("lazy")]), lazy(spanCounter)(div(euclideanRingInt)(counter)(2)), hr([]), h3([])([text("duplicate")]), div2([])(replicate(mod(euclideanRingInt)(counter)(4))(text("t")))]);
};
var keyDownHandler = function(v) {
  if (v === "i") {
    return new Just(Increment.value);
  }
  ;
  return Nothing.value;
};
var main = /* @__PURE__ */ function() {
  return app(monadAff)({
    init: {
      state: state3,
      action: Nothing.value
    },
    view,
    update,
    "eval": identity(categoryFn),
    subscriptions: [onKeyDown(keyDownHandler)],
    selector: "#root"
  });
}();

// <stdin>
main();
