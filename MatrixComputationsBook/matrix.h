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

    _T get(int i, int j) const {
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

    friend Matrix operator+(Matrix lhs, const Matrix& rhs) {
        Matrix ret;

        for (int i = 0; i < HEIGHT; ++i) {
            for (int j = 0; j < WIDTH; ++j) {
                ret(i,j) = lhs.get(i,j) + rhs.get(i,j);
            }
        }

        return ret;
    }

    friend Matrix operator*(_T scalar, const Matrix& rhs) {
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

template<typename _T, int HEIGHT1, int WIDTH1, int WIDTH2>
Matrix<_T, HEIGHT1, WIDTH2> operator*(const Matrix<_T, HEIGHT1, WIDTH1>& lhs, const Matrix<_T, WIDTH1, WIDTH2>& rhs) {
    Matrix<_T, HEIGHT1, WIDTH2> ret;
    
    for (int i = 0; i < HEIGHT1; ++i) {
        for (int j = 0; j < WIDTH2; ++j) {
            for (int k = 0; k < WIDTH1; ++k) {
                ret(i,j) += lhs.get(i,k) * rhs.get(k,j);
            }
        }
    }

    return ret;
}

template <typename _T, int HEIGHT> using ColVector = Matrix<_T, HEIGHT, 1>;

template <typename _T, int WIDTH> using RowVector = Matrix<_T, 1, WIDTH>;

template <typename _T, int LENGTH>
_T operator*(const RowVector<_T, LENGTH>& lhs, const ColVector<_T, LENGTH>& rhs) {
    _T result;
    for (int i = 0; i < LENGTH; ++i) {
        result += lhs.get(0,i) * rhs.get(i,0);
    }
    return result;
}