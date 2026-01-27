package org.handy.repository;

import org.handy.entity.ScheduleMst;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ScheduleMstRepository extends JpaRepository<ScheduleMst, String> {

}
