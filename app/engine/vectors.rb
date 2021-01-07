module Vectors
    def Vectors.subtract(v1, v2)
        v1.map.with_index { |v, i| v-v2[i]}
    end

    def Vectors.multiply_n(v1, n)
        v1.map { |v| v * n }
    end

    def Vectors.multiply(v1, v2)
        v1.zip(v2).map{ |x, y| x * y }
    end

    def Vectors.add(v1, v2)
        v1.zip(v2).map{ |x, y| x + y }
    end

    def Vectors.divide_n(v1, n)
        v1.map { |v| v / n }
    end

    def Vectors.normalize(v)
        divide_n(v, mag(v))
    end

    def Vectors.mag(v)
        Math.sqrt(v[0] ** 2 + v[1] ** 2)
    end
end