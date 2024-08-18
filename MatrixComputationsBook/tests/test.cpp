#include <matrix.h>

bool testMatrixVectorMult() {
    Matrix<int, 3, 2> mat;
    mat(0,0) = 1;
    mat(1,0) = 3;
    mat(2,0) = 5;
    mat(0,1) = 2;
    mat(1,1) = 4;
    mat(2,1) = 6;

    ColVector<int, 2> vec;
    vec(0) = 7;
    vec(1) = 8;

    auto res = mat * vec;
    res.print();

    ColVector<int, 3> exp;
    exp(0) = 23;
    exp(1) = 53;
    exp(2) = 83;

    if (res != exp) {
        std::cout << "FAIL" << std::endl;
        return false;
    }

    std::cout << "PASS" << std::endl;

    return true;
}


int main() {

    Matrix<int, 5, 6> mat;
    Matrix<int, 5, 6> mat2;

    mat.set(1,3,99);
    mat(2,2) = 55;
    // mat[4,1] = 44;

    mat2 = mat;

    mat.print();
    mat2.print();

    Matrix<int, 5, 6> mat3(mat2);
    mat3.print();
    mat3 = mat + mat2;
    mat3.print();

    Matrix<int, 6, 5> mat4(4*mat3.transpose());
    mat4.print();

    Matrix<int, 5, 6> mat6;
    mat6(0,1) = 1;
    mat6(1,0) = 1;
    mat6(2,3) = 1;
    mat6(3,2) = 1;
    mat6(4,4) = 1;
    mat6.print();
    Matrix<int, 5, 5> mat5 = mat6 * mat4;
    mat5.print();

    ColVector<int, 6> colvec;
    colvec(1) = 2;
    colvec(2) = 3;
    colvec(4) = 6;
    RowVector<int, 6> rowvec;
    rowvec(1) = 1;
    rowvec(2) = 2;
    rowvec(4) = 0;

    auto res = mat6 * colvec;
    res.print();

    auto res1 = rowvec * colvec;
    std::cout << res1 << std::endl;

    auto res2 = colvec * rowvec;
    res2.print();

    auto res3 = 5 * res2;
    res3.print();
    // std::cout << res2 << std::endl;
    // This fails to compile as expected because the types don't match up
    //mat3 = mat3.transpose();

    auto res4 = rowvec.transpose();
    res4.print();
    auto res5 = colvec.transpose();
    res5.print();

    testMatrixVectorMult();

    return 0;
}