#include <iostream>

using namespace std;

// HEIGHT = number of ROWS
// WIDTH  = number of COLUMNS
// An mxn Matrix has "m" rows and "n" columns

template <typename _T, int HEIGHT, int WIDTH>
class Matrix
{
private:
    _T data[HEIGHT][WIDTH];

public:
    Matrix() :
        data()
    {
        std::cout << "Creating " << HEIGHT << " x " << WIDTH << " matrix" << std::endl;
    }

    Matrix(const Matrix& rhs) :
        data()
    {
        std::cout << "Creating " << HEIGHT << " x " << WIDTH << " matrix" << std::endl;
        for (int i = 0; i < HEIGHT; ++i) {
            for (int j = 0; j < WIDTH; ++j) {
                this->data[i][j] = rhs.data[i][j];
            }
        }

    }

    Matrix& operator=(const Matrix& rhs) {
        Matrix ret;
        
        for (int i = 0; i < HEIGHT; ++i) {
            for (int j = 0; j < WIDTH; ++j) {
                this->data[i][j] = rhs.data[i][j];
            }
        }

        return *this;
    }

    _T get(int i, int j) {
        return data[i][j];
    }

    void set(int i, int j, const _T& value) {
        data[i][j] = value;
    }

    void print() const {
        std::cout << "[" << std::endl;
        for (int i = 0; i < HEIGHT; ++i) {
            std::cout << "  [";
            for (int j = 0; j < WIDTH; ++j) {
                std::cout << data[i][j] << ", ";
            }
            std::cout << "\b\b]," << std::endl;
        }
        std::cout << "]" << std::endl;
    }

    constexpr _T& operator()(size_t i, size_t j) {
        return data[i][j];
    }

    Matrix<_T, WIDTH, HEIGHT> transpose() const {
        Matrix<_T, WIDTH, HEIGHT> t;

        for (int i = 0; i < HEIGHT; ++i) {
            for (int j = 0; j < WIDTH; ++j) {
                t(j,i) = data[i][j];
            }
        }

        return t;
    }

    // TODO: Not sure why it didn't like when I made these const Matrix& types.
    friend Matrix operator+(Matrix lhs, Matrix rhs) {
        Matrix ret;

        for (int i = 0; i < HEIGHT; ++i) {
            for (int j = 0; j < WIDTH; ++j) {
                ret(i,j) = lhs.get(i,j) + rhs.get(i,j);
            }
        }

        return ret;
    }

    friend Matrix operator*(_T scalar, Matrix rhs) {
        Matrix ret;

        for (int i = 0; i < HEIGHT; ++i) {
            for (int j = 0; j < WIDTH; ++j) {
                ret(i,j) = scalar * rhs.get(i,j);
            }
        }

        return ret;
    }


    // I think this is only supported in C++23, not C++20
    // constexpr _T& operator[](size_t i, size_t j) {
    //     return data[i][j];
    // }

};