# generate_rns.sage
# 
# Includes sage functions for generating random numerical semigroups. 
# Requires Christopher O'Neill's Sage wrapper for the numericalsgps GAP package:
# https://github.com/coneill-math/numsgps-sage

import random

path_to_package = ""
load(path_to_package)

def build_rns(p, m, M):
    """Generate a random numerical semigroup from the given parameters.
    
    Args:
        p (float): probability for selecting a generator; must be between 0 and 1, inclusive.
        m (int): the semigroup's multiplicity. Must be positive.
        M (int): the upper bound for generator selection. Must be greater than the multiplicity.
        
    Returns:
        NumericalSemigroup: the randomly generated semigroup. 
    """
    if p > 1 or p < 0:
        print "Invalid input: probability (p) must be between 0 and 1, inclusive"
        return None
    if m < 1:
        print "Invalid input: multiplicity (m) must be positive"
        return None
    if m > M:
        print "Invalid input: maximum (M) must be greater than multiplicity (m)"
        return None
    gens = [m]
    for i in range(m + 1, M + 1):
        if random.random() < p:
            gens.append(i)
    for j in range(M + 1, M + m + 1):
        gens.append(j)
    return NumericalSemigroup(gens)

def sample(filename, times, p_list, m_list, M_list):
    """Creates a sample set of random numerical semigroups and writes out the results.
    
    Output is a semicolon-separated text file with the following columns:
    
    (blank): index column.
    p: p values.
    m: m values.
    M: M values.
    gens: list of generators for the semigroup (will use Python list notation).
    e: the semigroup's embedding dimension.
    F: the semigroup's Frobenius number.
    g: the semigroup's genus.
    t: the semigroup's type.
    
    Args:
        filename (string): name of output file.
        times (int): the number of random semigroups that should be generated for each parameter set.
        p_list (list of floats): p values to select from.
        m_list (list of ints): m values to select from.
        M_list (list of ints): M values to select from.
    (See documentation for build_rns function for parameter limitations)
    """
    doc = open(filename, 'w')
    doc.write(";p;m;M;gens;e;F;g;t")
    doc.write("\r\n")
    index = 0
    for p in p_list:
        for m in m_list:
            for M in M_list:
                for i in range(0, times):
                    rns = build_rns(p, m, M)
                    if rns:
                        write_string = ";".join([str(index), str(p), str(m), str(M), str(rns.gens), str(len(rns.gens)), 
                                                 str(rns.FrobeniusNumber()), str(len(rns.Gaps())), str(rns.Type())]) 
                        doc.write(write_string)
                        doc.write("\r\n")
                        index += 1
    doc.close()

# Usage example

filename = "example.txt"
times = 100
p_list = [0.2, 0.5]
m_list = [3, 26]
M_list = [100, 1000]

sample(filename, times, p_list, m_list, M_list)
