import foo

set_option pp.notation false

def test1 : Prop := test

theorem test2 {p : Prop} {q : Prop} : p ∨ q → q ∨ p :=
begin
  intro h,
  cases h with h1 h2,
    apply or.inr,
    exact h1,
    apply or.inl,
    assumption,
end
