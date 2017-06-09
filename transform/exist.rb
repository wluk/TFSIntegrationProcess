def transform_config_files(ctt, source_dir, dest_dir, config_file, transform_prefix, transform_postfix)
        config_files = Dir["#{source_dir}/#{transform_prefix}*#{transform_postfix}"].sort

        if config_files.length > 0
            config_file_groups = config_files.group_by {|f| File.basename(f)[transform_prefix.length..f.length].split('.')[0]}
            config_file_groups.each do |key, array|
                transform_file(ctt, "#{source_dir}/#{config_file}", array.last, dest_dir)

                not_transformed_file = "#{dest_dir}/#{config_file}"
                if File.exist?(not_transformed_file)
                    FileUtils.rm not_transformed_file
                end

                if array.length > 1
                    source_file = "#{dest_dir}/" + File.basename(array.pop)
                    array.each {|f| transform_file(ctt, source_file, f, dest_dir) }
                    FileUtils.rm "#{dest_dir}/" + File.basename(source_file)
                end
            end
        end
    end

    def transform_file(ctt, source_file, trans_file, dest_dir)
        dest_file = "#{dest_dir}/" + File.basename(trans_file)
        sh "#{ctt} pw s:\"#{source_file}\" t:\"#{trans_file}\" d:\"#{dest_file}\" i"
    end
end