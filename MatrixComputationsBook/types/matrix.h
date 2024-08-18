#include <iostream>
#include <assert.h>

using namespace std;

// HEIGHT = number of ROWS
// WIDTH  = number of COLUMNS
// An mxn Matrix has "m" rows and "n" columns

template <typename _T, size_t HEIGHT, size_t WIDTH>
class Matrix
{
protected:
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
        for (size_t i = 0; i < HEIGHT; ++i) {
            for (size_t j = 0; j < WIDTH; ++j) {
                this->data[i][j] = rhs.data[i][j];
            }
        }
    }

    Matrix& operator=(const Matrix& rhs) {
        Matrix ret;
        
        for (size_t i = 0; i < HEIGHT; ++i) {
            for (size_t j = 0; j < WIDTH; ++j) {
                this->data[i][j] = rhs.data[i][j];
            }
        }

        return *this;
    }

    bool operator==(const Matrix& rhs) const {
        bool isEqual = true;
        
        for (size_t i = 0; i < HEIGHT; ++i) {
            for (size_t j = 0; j < WIDTH; ++j) {
                if (this->data[i][j] != rhs.data[i][j]) {
                    return false;
                }
            }
        }

        return true;
    }

    bool operator!=(const Matrix& rhs) const {
        return !operator==(rhs);
    }

    _T get(size_t i, size_t j) const {
        return data[i][j];
    }

    void set(size_t i, size_t j, const _T& value) {
        assert(i <= HEIGHT);
        assert(j <= WIDTH);

        data[i][j] = value;
    }

    void print() const {
        std::cout << "[" << std::endl;
        for (size_t i = 0; i < HEIGHT; ++i) {
            std::cout << "  [";
            for (size_t j = 0; j < WIDTH; ++j) {
                std::cout << data[i][j] << ", ";
            }
            std::cout << "\b\b]," << std::endl;
        }
        std::cout << "]" << std::endl;
    }

    constexpr _T& operator()(size_t i, size_t j) {
        assert(i <= HEIGHT);
        assert(j <= WIDTH);

        return data[i][j];
    }

    Matrix<_T, WIDTH, HEIGHT> transpose() const {
        Matrix<_T, WIDTH, HEIGHT> t;

        for (size_t i = 0; i < HEIGHT; ++i) {
            for (size_t j = 0; j < WIDTH; ++j) {
                t(j,i) = data[i][j];
            }
        }

        return t;
    }

    friend Matrix operator+(Matrix lhs, const Matrix& rhs) {
        Matrix ret;

        for (size_t i = 0; i < HEIGHT; ++i) {
            for (size_t j = 0; j < WIDTH; ++j) {
                ret(i,j) = lhs.get(i,j) + rhs.get(i,j);
            }
        }

        return ret;
    }

    friend Matrix operator*(_T scalar, const Matrix& rhs) {
        Matrix ret;

        for (size_t i = 0; i < HEIGHT; ++i) {
            for (size_t j = 0; j < WIDTH; ++j) {
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

template<typename _T, size_t HEIGHT1, size_t WIDTH1, size_t WIDTH2>
Matrix<_T, HEIGHT1, WIDTH2> operator*(const Matrix<_T, HEIGHT1, WIDTH1>& lhs, const Matrix<_T, WIDTH1, WIDTH2>& rhs) {
    Matrix<_T, HEIGHT1, WIDTH2> ret;
    
    for (size_t i = 0; i < HEIGHT1; ++i) {
        for (size_t j = 0; j < WIDTH2; ++j) {
            for (size_t k = 0; k < WIDTH1; ++k) {
                ret(i,j) += lhs.get(i,k) * rhs.get(k,j);
            }
        }
    }

    return ret;
}

template<typename _T, size_t HEIGHT, size_t WIDTH>
Matrix<_T, HEIGHT, WIDTH> operator*(_T scalar, const Matrix<_T, HEIGHT, WIDTH>& rhs) {
    Matrix<_T, HEIGHT, WIDTH> ret;
    
    for (size_t i = 0; i < HEIGHT; ++i) {
        for (size_t j = 0; j < WIDTH; ++j) {
            ret(i,j) += scalar * rhs.get(i,j);
        }
    }

    return ret;
}

template <typename _T, size_t WIDTH>
class RowVector;

template <typename _T, size_t HEIGHT>
class ColVector : public Matrix<_T, HEIGHT, 1>
{
public:
    _T get(size_t i) const {
        assert(i <= HEIGHT);
        return this->data[i][0];
    }

    void set(size_t i, const _T& value) {
        assert(i <= HEIGHT);
        this->data[i][0] = value;
    }

    constexpr _T& operator()(size_t i) {
        assert(i <= HEIGHT);
        return this->data[i][0];
    }
    
    RowVector<_T, HEIGHT> transpose() const {
        RowVector<_T, HEIGHT> t;

        for (size_t i = 0; i < HEIGHT; ++i) {
            t(i) = this->data[i][0];
        }

        return t;
    }
};

template <typename _T, size_t WIDTH>
class RowVector : public Matrix<_T, 1, WIDTH>
{
public:
    _T get(size_t i) const {
        assert(i <= WIDTH);
        return this->data[0][i];
    }

    void set(size_t i, const _T& value) {
        assert(i <= WIDTH);
        this->data[0][i] = value;
    }

    constexpr _T& operator()(size_t i) {
        assert(i <= WIDTH);
        return this->data[0][i];
    }

    ColVector<_T, WIDTH> transpose() const {
        ColVector<_T, WIDTH> t;

        for (size_t i = 0; i < WIDTH; ++i) {
            t(i) = this->data[0][i];
        }

        return t;
    }
};

template <typename _T, size_t LENGTH>
_T operator*(const RowVector<_T, LENGTH>& lhs, const ColVector<_T, LENGTH>& rhs) {
    _T result = 0;
    for (size_t i = 0; i < LENGTH; ++i) {
        result += lhs.get(i) * rhs.get(i);
        std::cout << "interim result = " << result << std::endl;
    }
    return result;
}