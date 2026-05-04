package org.handy.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.handy.dto.FileMstDto;

@Mapper
public interface FileMstMapper {
    void insertFileMst(FileMstDto fileMstDto);
}
