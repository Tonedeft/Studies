#include <matrix.h>

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

    // This fails to compile as expected because the types don't match up
    //mat3 = mat3.transpose();

    return 0;
}