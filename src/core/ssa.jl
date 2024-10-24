
function SSATraj(X::Vector{Int}, T, rates, model::DiscreteModel) where {DiscreteModel}
  println(T)
  tau = T[1]
  j = 0
  traj = []
  while tau <= T[2]
    # sample two random numbers 
    i = rand()
    j = rand()
    # compute propensities and sum 
    A = [α(X, rates, tau) for α in model.propensities]
    α_sum = sum(A)
    # compute next reaction and time 
    δt = (1.0 / α_sum) * (exp(1.0 / j))
    j = findfirst(x -> x < j, cumsum(A))
    # update state 
    push!(traj, (tau + δt, X + model.stoichvecs[j]))
    tau = tau + δt
  end
end
