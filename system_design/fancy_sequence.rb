class Fancy
  MOD = 1_000_000_007

  def initialize
    @seq = []
    @add = 0
    @mult = 1
  end

  def append(val)
    # We store a "normalized" value.
    # The actual value is (normalized_val * @mult + @add)
    # So, to store `val`, we need to solve for normalized_val:
    # val = normalized_val * @mult + @add
    # normalized_val = (val - @add) / @mult
    # Division is multiplication by modular inverse.

    # (val - @add) % MOD
    val_minus_add = (val - @add + MOD) % MOD

    # Modular inverse of @mult
    inv_mult = power(@mult, MOD - 2)

    normalized_val = (val_minus_add * inv_mult) % MOD
    @seq << normalized_val
  end

  def add_all(inc)
    @add = (@add + inc) % MOD
  end

  def mult_all(m)
    @mult = (@mult * m) % MOD
    @add = (@add * m) % MOD
  end

  def get_index(idx)
    return -1 if idx >= @seq.length

    normalized_val = @seq[idx]
    # Apply current transformations
    ((normalized_val * @mult) + @add) % MOD
  end

  private

  # Helper for modular exponentiation (for modular inverse)
  def power(base, exp)
    res = 1
    base %= MOD
    while exp > 0
      res = (res * base) % MOD if exp.odd?
      base = (base * base) % MOD
      exp >>= 1
    end
    res
  end
end
