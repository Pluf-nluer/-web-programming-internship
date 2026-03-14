package com.example.backend.service;

import com.example.backend.dao.BannerDAO;
import com.example.backend.model.Banner;

import java.util.List;

public class BannerService {
    private BannerDAO bannerDAO = new BannerDAO();

    public List<Banner> getBannersDefaults() {
        return bannerDAO.getBannerDefault();
    }
}
