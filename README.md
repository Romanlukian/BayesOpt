A group of classes to implement the Bayesian Optimisation algorithm. Several
surrogate models and acquisition function approaches are implemented.

List of classes:

bayesOpt            - User interface class.
acqFcn              - An abstract class defining the acquisition function interface and
                      a template method to maximise the function.
expectedImprovement - Concrete EI acquisition function implementation
ucb                 - Concrete upper confidence bound acquisition function implementation
surrogateModel      - Abstract surrogate model interface.
gpr                 - Concrete gaussian process regression model. Wrapper for RegressionGP class
rf                  - Concrete random forest model. Wrapper for TreeBagger class
gprFitMethod        - Enumeration class for gpr model fitting methods
gprPredMethod       - Enumeration class for gpr prediction methods
kernels             - Enumeration class for supported gaussian process kernel functions



