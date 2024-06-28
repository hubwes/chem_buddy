import 'package:equations/equations.dart';

class SplineInterpolator {
  final List<double> x;
  final List<double> y;
  late final SplineInterpolation _spline;

  SplineInterpolator(this.x, this.y) {
    _spline = SplineInterpolation(
      nodes: List.generate(x.length, (index) => InterpolationNode(x: x[index], y: y[index])),
    );
  }

  double interpolate(double xVal) {
    return _spline.compute(xVal);
  }

  double derivative(double xVal) {
    // Calculate the first derivative using numerical differentiation
    const h = 1e-5;
    return (_spline.compute(xVal + h) - _spline.compute(xVal - h)) / (2 * h);
  }
}
