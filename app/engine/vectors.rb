module Vectors
    def Vectors.subtract(v1, v2)
        v1.map.with_index { |v, i| v-v2[i]}
    end

    def Vectors.multiply_by(v1, n)
        v1.map { |v| v * n }
    end

    def Vectors.multiply(v1, v2)
        v1.zip(v2).map{ |x, y| x * y }
    end

    def Vectors.add(v1, v2)
        v1.zip(v2).map{ |x, y| x + y }
    end

    def Vectors.divide_by(v1, n)
        v1.map { |v| v / n }
    end

    def Vectors.normalize(v)
        norm = divide_by(v, mag(v))
        norm[0] = 0 if norm[0].nan?
        norm[1] = 0 if norm[1].nan?
        norm
    end

    def Vectors.mag(v)
        Math.sqrt(v[0] ** 2 + v[1] ** 2)
    end

    def Vectors.truncate(v, max)
        i = max / mag(v)
        i = i < 1.0 ? i : 1.0
        multiply_n(v, i)
    end
end