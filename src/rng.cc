//---------------------------------*-C++-*-----------------------------------//
/*!
 * \file   src/algorithm.cc
 * \author Seth R Johnson
 * \date   Tue Oct 10 12:19:21 2017
 * \brief  shuffle class definitions.
 * \note   Copyright (c) 2017 Oak Ridge National Laboratory, UT-Battelle, LLC.
 */
//---------------------------------------------------------------------------//

#include "algorithm.hh"

#include <stdexcept>
#include <random>
#include <algorithm>

namespace
{
//---------------------------------------------------------------------------//
// Global RNG
std::mt19937* g_generator = nullptr;
}

//---------------------------------------------------------------------------//
/*!
 * \brief Initialize the RNG
 */
void init_rng(int seed)
{
    delete g_generator;
    g_generator = new std::mt19937(seed);
}

//---------------------------------------------------------------------------//
/*!
 * \brief Shuffle elements in the array using the global rng
 */
template<class T>
void shuffle(T *DATA, int SIZE)
{
    if (!g_generator)
        throw std::logic_error("RNG was not initialized");
    std::shuffle(view.first, view.first + view.second, *g_generator);
}

//---------------------------------------------------------------------------//
// EXPLICIT INSTANTIATIONS
//---------------------------------------------------------------------------//
template void shuffle<float>( std::pair<float*,  std::size_t>);
template void shuffle<double>(std::pair<double*, std::size_t>);
template void shuffle<int>(   std::pair<int*,    std::size_t>);

//---------------------------------------------------------------------------//
// end of src/algorithm.cc
//---------------------------------------------------------------------------//
