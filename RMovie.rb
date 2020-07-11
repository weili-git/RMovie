# Encoding: UTF-8

class RMovie
    def initialize(filename)
        @filename = filename
        info()
    end
    def info
        system "ffmpeg -i #{@filename} -hide_banner"
    end
    def subclip(start_, end_, output_)
        system "ffmpeg -ss #{start_} -i #{@filename} -to #{end_} -c copy #{output_}"
    end
    def slice(start_, time_, output_)
        system "ffmpeg -ss #{start_} -i #{@filename} -t #{time_} -c copy #{output_}"
    end
    def concat(list_, output_)
        system "ffmpeg -f concat -i #{list_} -c copy #{output_}"
    end
    def transmuxing(output_)  # change container format
        system "ffmpeg -i #{@filename} -c copy #{output_}"
    end
    def snapshot(start_, quality_, output_)  # quality 1-5, 1:best
        system "ffmpeg -ss #{start_} -i #{@filename} -vframes 1 -q:v #{quality_} #{output_}"
    end
    def repeat(start_, time_, times_, output_)
        f = File.new("temp.txt", "w")
        times_.times do |i|
            slice(start_, time_, "#{i}.mp4")  # not rm.slice
            f.syswrite("file '#{i}.mp4'\n")
        end
        f.close
        concat("temp.txt", output_)
        # delete temp files
        times_.times do |i|
            File.delete("#{i}.mp4")
        end
        File.delete("temp.txt")
    end
end

rm = RMovie.new("test.mp4")
# rm.slice(60, 3, "out.mp4")
rm.repeat(62, 1, 10, "out.mp4")  # float seconds unavailable
gets
