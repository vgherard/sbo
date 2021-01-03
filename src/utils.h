#if !defined(UTILS_H)
#define UTILS_H

template<class T>
class CircularBuffer {
        size_t size_;
        size_t pos_;
        std::vector<T> stream_;
public:
        // Constructor, initializing first size_ - 1 positions to 'init'. 
        CircularBuffer (size_t size, T init) 
                : size_(size), pos_(0), stream_(size)
        {
                for (; pos_ < size_ - 1; ++pos_) stream_[pos_] = init;
        }
        void push (const T& t) {
                stream_[pos_] = t;
                pos_ = (pos_ + 1) % size_;
        }
        // Element access
        T at(size_t i) const { return stream_[(pos_ + i) % size_]; }
        T last() const { return at(size_ - 1); }
        // size
        size_t size() const { return size_; }
};

#endif