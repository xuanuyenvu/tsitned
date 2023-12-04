  import nhasi from "../../fakedata/nhasi";
  import React from "react";
  import { Table, Modal, Button, message, Tag } from "antd";
  import ColumnSearch from "~/hooks/useSortTable";
  import { useState } from "react";


  const NhaSiTable = ({ data }) => {
    const format = (text) => {
      const replacedText = text.replace(/\\n/g, "\n");
      const lines = replacedText.split("\n");
      return lines.map((line, index) => (
        <React.Fragment key={index}>
          {line}
          <br />
        </React.Fragment>
      ));
    };
    const columns = [
      {
        title: "Mã NS",
        dataIndex: "MANS",
        key: "MANS",
        className: "text-center  min-w-[100px] ",
        ...ColumnSearch("MANS", "Mã NS"),
      },
      {
        title: "Họ và tên",
        dataIndex: "HOTEN",
        key: "HOTEN",
        className: "text-center  min-w-[100px] ",

        ...ColumnSearch("HOTEN", "Họ và tên"),
      },
      {
        title: "Giới tính",
        dataIndex: "PHAI",
        className: "text-center  min-w-[100px] ",
        key: "PHAI",
      },
      {
        title: "Giới thiệu",
        dataIndex: "GIOITHIEU",
        key: "GIOITHIEU",
        render: (text) => format(text),
      },

      {
        title: "Đã khóa",
        dataIndex: "_DAKHOA",
        key: "_DAKHOA",
        render: (_, record) => {
          const tags = record._DAKHOA ? ["Locked"] : ["Open"]; // Update with your custom status values
          return (
            <>
              {tags.map((tag) => {
                let color = tag === "Locked" ? "volcano" : "green"; // Customize colors based on status
                return (
                  <Tag color={color} key={tag}>
                    {tag.toUpperCase()}
                  </Tag>
                );
              })}
            </>
          );
        },
      },
    ];

    const paginationOptions = {
      pageSize: 4,
      total: data.length,
      showSizeChanger: true,
      showQuickJumper: true,
    };

    return (
      <Table
        className="table-striped w-full"
        columns={columns}
        dataSource={data.map((item, index) => ({ ...item, key: index }))}
        pagination={paginationOptions}
        bordered
        size="middle"
      />
    );
  };

  const DanhSachNS = () => {
    return (
      <>
        <div className=" w-full z-0">
          <NhaSiTable data={nhasi} />
        </div>
      </>
    );
  };

  export default DanhSachNS;