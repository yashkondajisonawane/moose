[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 1
  ny = 1
[]

[Variables]
  [u]
  []
[]

[Distributions]
  [uniform_left]
    type = UniformDistribution
    lower_bound = 0
    upper_bound = 0.5
  []
  [uniform_right]
    type = UniformDistribution
    lower_bound = 1
    upper_bound = 2
  []
[]

[Samplers]
  [sample]
    type = SobolSampler
    num_rows = 3
    distributions = 'uniform_left uniform_right'
    execute_on = INITIAL # create random numbers on initial and use them for each timestep
  []
[]

[MultiApps]
  [sub]
    type = TransientMultiApp
    input_files = sub.i
    positions = '0 0 0'
  []
[]

[Transfers]
  [runner]
    type = SamplerTransfer
    multi_app = sub
    sampler = sample
    parameters = 'BCs/left/value BCs/right/value'
    to_control = 'stochastic'
    execute_on = INITIAL
    check_multiapp_execute_on = false
  []
  [data]
    type = SamplerPostprocessorTransfer
    multi_app = sub
    sampler = sample
    vector_postprocessor = storage
    postprocessor = avg
    execute_on = timestep_end
    check_multiapp_execute_on = false
  []
[]

[VectorPostprocessors]
  [storage]
    type = StochasticResults
    samplers = sample
  []
[]

[Executioner]
  type = Transient
  num_steps = 5
  dt = 0.01
[]

[Problem]
  solve = false
  kernel_coverage_check = false
[]

[Outputs]
  csv = true
[]